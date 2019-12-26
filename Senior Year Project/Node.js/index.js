var fs = require('fs');
var os = require("os");
var sios = require('socket.io');
var http = require('http');
var https = require('https');
var port=process.env.PORT || 8000;
var callarray = [];
var agentarray = [];
var MaxQueueTime = 0;
var infoObj = {CallersNo:0, AgentsNo:0};
var StartTime = Date.now();
var ArriPerSec = 0;
var InterArriTime = 0;

var TotalServicTime = 0;
var MeanCalltime = 0;
var TotalCallServ = 0;
var Drops = 0;
var BlockPercen = 0;
var TotalQueueTime = 0;
var AvgQueTime = 0;
var Abandon = 0;
var AbandonPercen = 0;
var PercenCallServ = 0;
var Passive = 0;
var Promoter = 0;
var Detractor = 0;
var NetPromoScore = 0;
var AgentAvail = 0;
var AgentBusy = 0;
var Utilization = 0;
var TotCallerTime = 0;
var AvgCallerTime = 0;
var AgenSalary = 0;
var QualityScores = 0;
var Wait = 0;
var ProbWait = 0;
var SevicThresh = 10000;
var ServiceLevel = 0;
var CorreServiced = 0;
var MaxCallLen = 0;
var ServiceRate = 0;
var TrafficIntens = 0;
var Availablecallers = "";
var Availableagents = "";
const options = {
  key: fs.readFileSync('./ryans-key.pem'),
  cert: fs.readFileSync('./ryans-cert.pem')
};

var app = http.createServer(function (req, res) {
	//console.log('request was made: ' + req.url);
//console.log(req)
	if (req.url === '/')
		{fs.readFile('CallCentre.html', function(error,data){res.end(data);})}

	if ((req.url === '/Caller')||(req.url === '/caller'))
		{fs.readFile('caller.html', function(error,data){res.end(data);})}

	if ((req.url === '/Agent')||(req.url === '/agent'))
		{fs.readFile('agent.html', function(error,data){res.end(data);})}
  
}).listen(port);//10.103.76.173

const io = sios.listen(app);

// routing funbction

function RoutingCaller(PeerChosenName){
	
	for (var i = 0; i<callarray.length; i++){
		if(callarray[i].Servicing == false && callarray[i].Offered==true){
			for(var j = 0; j <agentarray.length; j++)
				if(((agentarray[j].Idle == true)&&((agentarray[j].Skill&callarray[i].Skill)==callarray[i].Skill))||((agentarray[j].Idle == true)&&(agentarray[j].Name==PeerChosenName))){
					callarray[i].PeerAgentSocket = agentarray[j].AgentSocket;
					agentarray[j].PeerCallerSocket = callarray[i].CallerSocket;
					agentarray[j].RoutingTime = Date.now();
                    AgenSalary += agentarray[j].Wage;
					console.log('connected Agent '+j+'to Caller '+i);
					agentarray[j].Idle = false;
					callarray[i].Servicing = true;
					callarray[i].dequeueTime=Date.now();
					callarray[i].QueueTime=callarray[i].dequeueTime- callarray[i].EnqueueTime;
                    if(callarray[i].QueueTime <= SevicThresh)
                    {
                              CorreServiced++;

                    }
                    ServiceLevel = (CorreServiced/(infoObj.CallersNo))*100;
					if(callarray[i].QueueTime >= 1000)
					{
						Wait++;
					}
					ProbWait = (Wait/(infoObj.CallersNo))*100;
					TotalQueueTime = TotalQueueTime + callarray[i].QueueTime;
          TotalCallServ++;
                    AvgQueTime = TotalQueueTime/(TotalCallServ);

					if(MaxQueueTime<callarray[i].QueueTime){MaxQueueTime=callarray[i].QueueTime;}
					callarray[i].PeerAgentSocket.emit('offer',callarray[i].SDP);
					callarray[i].PeerAgentSocket.emit('offerName',callarray[i].Name);
					callarray[i].CallerSocket.emit('offerName',agentarray[i].Name);	
					ServiceRate = TotalCallServ/(Date.now() - StartTime);
          TrafficIntens = ArriPerSec/ServiceRate;
                    PercenCallServ = TotalCallServ/infoObj.CallersNo;

                   Promoter = infoObj.CallersNo*9;
                   Detractor = Abandon*4;
                   Passive = ((Drops)+(0.5*infoObj.CallersNo))*7;
                   NetPromoScore = ((Promoter - Detractor)/(Promoter + Detractor + Passive))*100;
                   QualityScores = infoObj.CallersNo - Abandon - Drops;
					j=agentarray.length;
				}
			}
		}

}


function RoutingAgent(PeerChosenName){
	
	for (var i = 0; i<callarray.length; i++){
		if(callarray[i].Servicing == false && callarray[i].Offered==true){
			for(var j = 0; j <agentarray.length; j++)
				if(((agentarray[j].Idle == true)&&((agentarray[j].Skill&callarray[i].Skill)==callarray[i].Skill))||((agentarray[j].Idle == true)&&(callarray[i].Name==PeerChosenName))){
					callarray[i].PeerAgentSocket = agentarray[j].AgentSocket;
					agentarray[j].PeerCallerSocket = callarray[i].CallerSocket;
					agentarray[j].RoutingTime = Date.now();
                    AgenSalary += agentarray[j].Wage;
					console.log('connected Agent '+j+'to Caller '+i);
					agentarray[j].Idle = false;
					callarray[i].Servicing = true;
					callarray[i].dequeueTime=Date.now();
					callarray[i].QueueTime=callarray[i].dequeueTime- callarray[i].EnqueueTime;
                    if(callarray[i].QueueTime <= SevicThresh)
                    {
                              CorreServiced++;

                    }
                    ServiceLevel = (CorreServiced/(infoObj.CallersNo))*100;
					if(callarray[i].QueueTime >= 1000)
					{
						Wait++;
					}
					ProbWait = (Wait/(infoObj.CallersNo))*100;
					TotalQueueTime = TotalQueueTime + callarray[i].QueueTime;
          TotalCallServ++;
                    AvgQueTime = TotalQueueTime/(TotalCallServ);

					if(MaxQueueTime<callarray[i].QueueTime){MaxQueueTime=callarray[i].QueueTime;}
					callarray[i].PeerAgentSocket.emit('offer',callarray[i].SDP);
					callarray[i].PeerAgentSocket.emit('offerName',callarray[i].Name);
					callarray[i].CallerSocket.emit('offerName',agentarray[i].Name);
					ServiceRate = TotalCallServ/(Date.now() - StartTime);
          TrafficIntens = ArriPerSec/ServiceRate;
                    PercenCallServ = TotalCallServ/infoObj.CallersNo;

                   Promoter = infoObj.CallersNo*9;
                   Detractor = Abandon*4;
                   Passive = ((Drops)+(0.5*infoObj.CallersNo))*7;
                   NetPromoScore = ((Promoter - Detractor)/(Promoter + Detractor + Passive))*100;
                   QualityScores = infoObj.CallersNo - Abandon - Drops;
					j=agentarray.length;
				}
			}
		}

}



function SendToPeer(Socket,Tag, Message){
	var flag = 0;
for(var i = 0; i<callarray.length; i++){
	if (callarray[i].PeerAgentSocket){
	if (callarray[i].CallerSocket == Socket){callarray[i].PeerAgentSocket.emit(Tag,Message);flag =1;
		}
	}
}
if(!flag){
	for(var j = 0; j<agentarray.length; j++){
	if (agentarray[j].PeerCallerSocket){
		if (agentarray[j].AgentSocket == Socket){agentarray[j].PeerCallerSocket.emit(Tag,Message);}
			}
		}	
	}
}

var logString="";

fs.readFile("log.txt", 'utf8', function (err,data) {
  if (err) {
    return console.log(err);
  }
logString=data;
});

function logfile()
{
logString+=(os.EOL+ArriPerSec +" "+InterArriTime +" "+TotalServicTime+" "+ MeanCalltime+" "+ TotalCallServ+" "+ Drops+" "+ BlockPercen+" "+ TotalQueueTime+" "+ AvgQueTime+" "+ Abandon +" "+AbandonPercen +" "+PercenCallServ +" "+Passive+" "+ Promoter +" "+Detractor+" "+ NetPromoScore +" "+AgentAvail +" "+AgentBusy+" "+ Utilization +" "+TotCallerTime +" "+AvgCallerTime+" "+ AgenSalary +" "+QualityScores+" "+ Wait+" "+ ProbWait+" "+ SevicThresh+" "+ ServiceLevel+" "+ CorreServiced+" "+ MaxCallLen+" "+ ServiceRate+" "+TrafficIntens);
fs.writeFile( "log.txt", logString, function(err)
{
	 if(err) {
        return console.log(err);
    }
    console.log("The file was saved!");
});

}


setInterval(logfile,60000);

io.on('connection', function (socket) {

	socket.emit('List',{CallersList:Availablecallers,AgentsList:Availableagents});
  
  socket.on('Type', function (data) {
  	console.log(data);
    if (data.type=='agent'){
		agentarray.push({AgentSocket:socket,Name:data.Name,StartServiceTime: Date.now() ,Wage:(data.Skill)*100,Skill:data.Skill,Idle: true, RoutingTime: "",PeerCallerSocket: "", QueueTime:0 ,EndServiceTime:"", TotalCallsServiced: 0,PeerChosen:data.PeerChosen});
			infoObj.AgentsNo++ ;
			socket.broadcast.emit('Information', infoObj);
			socket.broadcast.emit('List',{CallersList:Availablecallers,AgentsList:Availableagents});
			socket.emit('Information', infoObj);
			socket.emit('List',{CallersList:Availablecallers,AgentsList:Availableagents});
		Availableagents+=(" " + data.Name);
		RoutingAgent(data.PeerChosen);
		}
   
    else {
   	callarray.push({CallerSocket: socket,Name:data.Name, Skill:data.Skill,EnqueueTime:Date.now(), dequeueTime:"", Offered: false, PeerAgentSocket: "",EndServiceTime:"", ServiceTime:"",Servicing: false, SDP: {},PeerChosen:data.PeerChosen});
    infoObj.CallersNo++ ;
    var CurrenTime = Date.now();
    
    ArriPerSec = infoObj.CallersNo/(CurrenTime - StartTime);
    TrafficIntens = ArriPerSec/ServiceRate;
    InterArriTime = 1/(ArriPerSec);
    socket.broadcast.emit('Information', infoObj);
    socket.broadcast.emit('List',{CallersList:Availablecallers,AgentsList:Availableagents});
    socket.emit('Information', infoObj);
    socket.emit('List',{CallersList:Availablecallers,AgentsList:Availableagents});
    Availablecallers+=(" " + data.Name);
   		RoutingCaller(data.PeerChosen);
   		}
   		
    }

 );

socket.on('iceCandidate', function(candidate){
	SendToPeer(socket,"iceCandidate", candidate );
});

socket.on('offer',function(offer){
	for(i=0;i<callarray.length;i++){
		if (callarray[i].CallerSocket==socket){
			callarray[i].SDP = offer;
			callarray[i].Offered = true;
		RoutingCaller(callarray[i].PeerChosen);
		}	
	}
	
});

socket.on('TextMessage', function(Message){
	SendToPeer(socket, 'TextMessage', Message);
});

socket.on('answer',function(answer){
	SendToPeer(socket,'answer',answer);
});

// socket listen the file information from the caller and send it to the agent, agent then saves that info
socket.on('fileInformation',function(fileInformation) {SendToPeer(socket,'fileInformation',fileInformation)});
socket.on('StartSendingFile',function(StartSendingFile) {SendToPeer(socket,'StartSendingFile',StartSendingFile)});
socket.on('CompleteFileReceived',function(){SendToPeer(socket,"CompleteFileReceived","")});


   
    

socket.on('disconnect', function(){
  for(i=0;i<infoObj.CallersNo; i++) {
  	if (callarray[i].CallerSocket === socket){
        
        console.log("caller "+i+" left");
        Availablecallers=Availablecallers.replace(" "+callarray[i].Name,"");
  		  if(callarray[i].Offered == false)
  		  {Drops++;
  		  	BlockPercen = (Drops/infoObj.CallersNo)*100;
          callarray[i].dequeueTime=Date.now();
  		  }
  		  else
  		  {
  		  	if(callarray[i].Servicing == false)
  		  		{Abandon++;
  		  	 AbandonPercen = Abandon/(infoObj.CallersNo)*100;
           callarray[i].dequeueTime=Date.now();
          }
  		  }
        callarray[i].Servicing=true;
  		//callarray.splice(i,1);
  		callarray[i].EndServiceTime = Date.now();
  		callarray[i].ServiceTime = callarray[i].EndServiceTime - callarray[i].dequeueTime;
  		if(callarray[i].ServiceTime > MaxCallLen)
  		{
  			MaxCallLen = callarray[i].ServiceTime;
  		}
        TotalServicTime = TotalServicTime + callarray[i].ServiceTime;
        MeanCalltime = TotalServicTime/TotalCallServ;
        callarray[i].Offered=false;
        TotCallerTime += callarray[i].dequeueTime - callarray[i].EnqueueTime;
        AvgCallerTime = TotCallerTime/(infoObj.CallersNo);
        //fs.writeFile();
logString+=(os.EOL+"callerLeft "+callarray[i].Name+" "+callarray[i].Skill+" "+callarray[i].Wage+" "+callarray[i].EnqueueTime+" "+callarray[i].dequeueTime+" "+callarray[i].Offered+" "+callarray[i].EndServiceTime+" "+callarray[i].ServiceTime+" "+callarray[i].Servicing);
        fs.writeFile( "log.txt", logString,function(err){});
  	}}


  

  	for(i=0;i<infoObj.AgentsNo; i++) {
  	if (agentarray[i].AgentSocket === socket){
      console.log("Agent "+i+" left");
      Availableagents=Availableagents.replace(" "+agentarray[i].Name,"");
      agentarray[i].EndServiceTime=Date.now();
  		AgentAvail += agentarray[i].EndServiceTime - agentarray[i].StartServiceTime;
        AgentBusy += agentarray[i].EndServiceTime - agentarray[i].RoutingTime;
        Utilization = (AgentBusy/AgentAvail)*100;
        agentarray[i].Idle=false;
       logString+=(os.EOL+"Agent Left "+agentarray[i].Name+" "+agentarray[i].StartServiceTime+" "+agentarray[i].Wage+" "+agentarray[i].Skill+" "+agentarray[i].Idle+" "+agentarray[i].RoutingTime+" "+agentarray[i].QueueTime+" "+agentarray[i].EndServiceTime+" "+agentarray[i].TotalCallsServiced);
        fs.writeFile( "log.txt", logString,function(err){});
 

  		//agentarray.splice(i,1);
    }
  }
});


});