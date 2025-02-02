%PlotCosts.m
function PlotCosts(pop,rep)
pop_costs=[pop.Cost];
 plot(pop_costs(2,:),pop_costs(3,:),'k.', 'markersize', 12);
 hold on;
 rep_costs=[rep.Cost];
 %plot3(rep_costs(1,:),rep_costs(2,:), rep_costs(3,:),'r*', 'markersize', 12);
 plot(rep_costs(2,:),rep_costs(3,:),'g*', 'markersize', 12);
 %xlabel('Net Power (MW)');
 xlabel('CO2 Emission (gr/MJ)');
 ylabel('Exergy Efficiency (%)');
 legend('Pop Cost','Rep Cost');
 title('MOHHO Pareto Front for Exergy Efficiency vs CO2 Emission');
 grid on;
 % 
 hold off;
end
