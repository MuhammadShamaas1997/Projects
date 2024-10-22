# euro2024.mod

# Sets
set T := {'GER', 'SCO', 'HUN', 'SUI', 'ESP', 'CRO', 'ITA', 'ALB', 'SVN', 'DEN', 'SRB', 'ENG', 'POL', 'NED', 'AUT', 'FRA', 'BEL', 'SVK', 'ROU', 'UKR', 'TUR', 'GEO', 'POR', 'CZE'}; #Teams
set G := {"A", "B", "C", "D", "E", "F"};  # Groups
set V := {"BER", "MUN", "DOR", "STU", "GEL", "HAM", "DUS", "FRK", "COL", "LEI"};  # Venues
set D := 14..26;  # Dates (from 14 to 26)
set M := 1..36;  # Matches
set K := 1..3;  # Match indices
set EarlyDates := {d in D: d <= 18};
set LateDates := {d in D: d >= 24};
set MatchTeams{M} within T;  # Teams playing in match m
set GroupTeams{G} within T;  # Teams in group g

# Parameters
param MatchesPerVenue{V} >= 0, integer;  # Number of matches per venue
param Distance{V,V} >= 0;  # Distance between venues
param MainSeededVenue{T} symbolic default "";  # Main-seeded teams' initial venue
param MatchDate{M} >= 14, <= 26;  # Date of match m
param TeamMatches{T,K} within M;  # The k-th match of team t
param MatchGroup{M} symbolic;  # Group of match m

# Decision Variables
var x{M,V} binary;  # x[m,v] = 1 if match m is assigned to venue v
var y{T,K,V,V} binary;  # y[t,k,v,v1] = 1 if team t plays match k at v and k+1 at v1
var GroupVenueUsed{G,V} binary;  # 1 if group g uses venue v

# Objective Function: Minimize total travel distance
minimize TotalDistance:
    sum {t in T, k in K, v in V, v1 in V : k <= 2} Distance[v,v1] * y[t,k,v,v1];

# Constraints

# 1. Match Assignment
s.t. MatchAssignment {m in M}:
    sum {v in V} x[m,v] = 1;

# 2. Venue Capacities
s.t. VenueCapacity {v in V}:
    sum {m in M} x[m,v] = MatchesPerVenue[v];

# 3. Minimum Two Days Between Matches at the Same Venue
set D2 := {d in D: d + 1 in D};
s.t. MinTwoDaysBetweenMatches {v in V, d in D2}:
    sum {m in M: MatchDate[m] = d} x[m,v] + sum {m in M: MatchDate[m] = d+1} x[m,v] <= 1;

# 4. Group Venue Usage
s.t. GroupVenueUsage {g in G, v in V, m in M: MatchGroup[m] = g}:
    x[m,v] - GroupVenueUsed[g,v] <= 0;

# 5. Minimum Venues per Group
s.t. MinVenuesPerGroup {g in G}:
    sum {v in V} GroupVenueUsed[g,v] >= 4;

# 6. Maximum of Two Matches per Venue per Group
s.t. MaxGroupMatchesPerVenue {g in G, v in V}:
    sum {m in M: MatchGroup[m] = g} x[m,v] <= 2;

# 7. Early Stage Requirement
s.t. EarlyStageRequirement {v in V}:
    sum {m in M: MatchDate[m] <= 18} x[m,v] >= 1;

# 8. Late Stage Requirement
s.t. LateStageRequirement {v in V}:
    sum {m in M: MatchDate[m] >= 24} x[m,v] >= 1;

# 9. Main-Seeded Teams' First Match Venue
set T_seeded := {t in T: MainSeededVenue[t] != ""};
s.t. MainSeededFirstMatch {t in T_seeded}:
    x[TeamMatches[t,1], MainSeededVenue[t]] = 1;

# 10. Linking y_{t,k,v,v'} with x_{m,v}
s.t. LinkingY1 {t in T, k in K, v in V, v1 in V: k <= 2}:
    y[t,k,v,v1] <= x[TeamMatches[t,k], v];

s.t. LinkingY2 {t in T, k in K, v in V, v1 in V: k <= 2}:
    y[t,k,v,v1] <= x[TeamMatches[t,k+1], v1];

s.t. LinkingY3 {t in T, k in K, v in V, v1 in V: k <= 2}:
    y[t,k,v,v1] >= x[TeamMatches[t,k], v] + x[TeamMatches[t,k+1], v1] - 1;
