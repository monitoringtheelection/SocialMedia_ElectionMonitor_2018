// Our labels along the x-axis
var time = ["00:00","01:00","02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00","13:00", "14:00", "15:00", "16:00", "17:00",  "18:00", "19:00", "20:00", "21:00", "22:00",  "23:00"];

var fraud = [ 365,298,397,681,813,1352,2464,1701,1372,1414,1173,810,781,1447,1033,1255,1494,1300,1381,1151,732,490,424,320 ];
var electionDayVoting = [ 451,362,406,432,573,798,1129,1123,957,1417,1854,1378,1118,1092,1179,956,1016,1252,2070,1994,1424,992,746,605 ];
var pollingPlaces = [ 0,0,0,0,0,0,0,0,0,0,8,1,3,3,3,2,6,2,1,3,1,1,0,2 ];
var remoteVoting = [ 30,13,16,42,83,218,221,162,196,125,163,97,128,191,89,96,131,166,94,89,102,67,27,17 ];
var voterID = [ 183,66,94,206,264,611,956,393,266,242,312,295,281,173,170,128,146,153,150,90,125,158,115,51 ];

var fraud_total = [ 24648 ];
var electionDayVoting_total = [ 25324 ];
var pollingPlaces_total = [ 36 ];
var remoteVoting_total = [ 2563 ];
var voterID_total = [ 5628 ];

var week = ["June 13", "June 14","Jun 15","Jun 16","Jun 17","Jun 18","Jun 19"]

var fraud_week = [ 22111,15889,12584,6447,11396,25712,24648 ]
var electionDayVoting_week = [ 99029,163997,85399,29965,18382,24390,25324 ]
var pollingPlaces_week = [ 25,49,11,12,29,15,36 ]
var remoteVoting_week = [ 2938,7275,5994,7406,5860,2324,2563 ]
var voterID_week = [ 10571,7082,2828,1829,2237,3290,5628 ]

var fraud_week_total = [ 118787 ]
var electionDayVoting_week_total = [ 446486 ]
var pollingPlaces_week_total = [ 177 ]
var remoteVoting_week_total = [ 34360 ]
var voterID_week_total = [ 33465 ]

var ctx = document.getElementById("myChart");

var myChart = new Chart (ctx, {
	type: 'line',
	data: {
		labels: time,
		datasets:[ 
			{ 
			  data: electionDayVoting,
			  label: "Election Day Voting",
			  borderColor: "#00A591",
			  fill: false
			},
			{ 
			  data: fraud,
			  label: "Voter Fraud",
			  borderColor: "#E94B3C",
			  fill: false
			},
			{ 
			  data: remoteVoting,
			  label: "Remote Voting",
			  borderColor: "#BC70A4",
			  fill: false
			},
			{ 
			  data: voterID,
			  label: "Voter ID",
			  borderColor: "#6F9FD8",
			  fill: false
			},
			{ 
			  data: pollingPlaces,
			  label: "Polling Places",
			  borderColor: "#6C4F3D",
			  fill: false
			}
		]
	},
	options: {
        responsive: true,
        title: {
            display: false,
            position: "top",
            text: "Hourly Frequencies",
            fontSize: 18,
            fontColor: "#111"
        },
        legend: {
            display: true,
            position: "bottom",
            labels: {
                fontColor: "#333",
                fontSize: 13
            }
        }
    }
})


var ctx2 = document.getElementById("myChart2");

var data1 = {
        labels: ["Election Day Voting", "Voter Fraud",  "Remote Voting", "Voter ID", "Polling Places",],
        datasets: [
            {
                label: "TeamA Score",
                data: [electionDayVoting_total, fraud_total, remoteVoting_total, voterID_total, pollingPlaces_total,],
                backgroundColor: [
                    "#00A591",
                    "#E94B3C",
                    "#BC70A4",
                    "#6F9FD8",
                    "#6C4F3D",
                ],
                borderColor: [
                    "#000000",
                    "#000000",
                    "#000000",
                    "#000000",
                    "#000000"
                ],
                borderWidth: [1, 1, 1, 1, 1]
            }
        ]
    };    
//options
    var options = {
        responsive: true,
        title: {
            display: false,
            position: "top",
            text: "Daily Totals",
            fontSize: 18,
            fontColor: "#111"
        },
        legend: {
            display: true,
            position: "bottom",
            labels: {
                fontColor: "#333",
                fontSize: 13
            }
        }
    };    

var myChart2 = new Chart(ctx2, {
        type: "doughnut",
        data: data1,
        options: options
    });

var ctx_week = document.getElementById("myChart_week");

var myChart_week = new Chart (ctx_week, {
    type: 'line',
    data: {
        labels: week,
        datasets:[ 
            { 
              data: electionDayVoting_week,
              label: "Election Day Voting",
              borderColor: "#00A591",
              fill: false
            },
            { 
              data: fraud_week,
              label: "Voter Fraud",
              borderColor: "#E94B3C",
              fill: false
            },
            { 
              data: remoteVoting_week,
              label: "Remote Voting",
              borderColor: "#BC70A4",
              fill: false
            },
            { 
              data: voterID_week,
              label: "Voter ID",
              borderColor: "#6F9FD8",
              fill: false
            },
            { 
              data: pollingPlaces_week,
              label: "Polling Places",
              borderColor: "#6C4F3D",
              fill: false
            }
        ]
    },
    options: {
        responsive: true,
        title: {
            display: false,
            position: "top",
            text: "Day Frequencies",
            fontSize: 18,
            fontColor: "#111"
        },
        legend: {
            display: true,
            position: "bottom",
            labels: {
                fontColor: "#333",
                fontSize: 13
            }
        }
    }
})




var ctx2_week = document.getElementById("myChart2_week");

var data1_week = {
        labels: ["Election Day Voting", "Voter Fraud",  "Remote Voting", "Voter ID", "Polling Places",],
        datasets: [
            {
                label: "TeamA Score",
                data: [electionDayVoting_week_total, fraud_week_total, remoteVoting_week_total, voterID_week_total, pollingPlaces_week_total,],
                backgroundColor: [
                    "#00A591",
                    "#E94B3C",
                    "#BC70A4",
                    "#6F9FD8",
                    "#6C4F3D",
                ],
                borderColor: [
                    "#000000",
                    "#000000",
                    "#000000",
                    "#000000",
                    "#000000"
                ],
                borderWidth: [1, 1, 1, 1, 1]
            }
        ]
    };    
//options
    var options = {
        responsive: true,
        title: {
            display: false,
            position: "top",
            text: "Daily Totals",
            fontSize: 18,
            fontColor: "#111"
        },
        legend: {
            display: true,
            position: "bottom",
            labels: {
                fontColor: "#333",
                fontSize: 13
            }
        }
    };    

var myChart2_week = new Chart(ctx2_week, {
        type: "doughnut",
        data: data1_week,
        options: options
    });

    
/*
var myChart2 = new Chart (ctx2, {
	type: 'doughnut',
	data: {
		labels:  ["Voter Fraud", "Election Day Voting", "Polling Places", "Remote Voting", "Voter ID"],
		datasets:[ 
			{ 
			  data: fraud_total,
			  label: "Voter Fraud",
			  borderColor: "#E94B3C",
			  fill: false
			},
			{ 
			  data: electionDayVoting_total,
			  label: "Election Day Voting",
			  borderColor: "#E94B3C",
			  fill: false
			},
			{ 
			  data: pollingPlaces_total,
			  label: "Polling Places",
			  borderColor: "#E94B3C",
			  fill: false
			},
			{ 
			  data: remoteVoting_total,
			  label: "Remote Voting",
			  borderColor: "#E94B3C",
			  fill: false
			},
			{ 
			  data: voterID_total,
			  label: "Voter ID",
			  borderColor: "#E94B3C",
			  fill: false
			}
		]
	}
})
*/

/*
 //get the doughnut chart canvas
    var ctx1 = $("#doughnut-chartcanvas-1");
    var ctx2 = $("#doughnut-chartcanvas-2");

    //doughnut chart data
    var data1 = {
        labels: ["match1", "match2", "match3", "match4", "match5"],
        datasets: [
            {
                label: "TeamA Score",
                data: [10, 50, 25, 70, 40],
                backgroundColor: [
                    "#DEB887",
                    "#A9A9A9",
                    "#DC143C",
                    "#F4A460",
                    "#2E8B57"
                ],
                borderColor: [
                    "#CDA776",
                    "#989898",
                    "#CB252B",
                    "#E39371",
                    "#1D7A46"
                ],
                borderWidth: [1, 1, 1, 1, 1]
            }
        ]
    };

    //doughnut chart data
    var data2 = {
        labels: ["match1", "match2", "match3", "match4", "match5"],
        datasets: [
            {
                label: "TeamB Score",
                data: [20, 35, 40, 60, 50],
                backgroundColor: [
                    "#FAEBD7",
                    "#DCDCDC",
                    "#E9967A",
                    "#F5DEB3",
                    "#9ACD32"
                ],
                borderColor: [
                    "#E9DAC6",
                    "#CBCBCB",
                    "#D88569",
                    "#E4CDA2",
                    "#89BC21"
                ],
                borderWidth: [1, 1, 1, 1, 1]
            }
        ]
    };

    //options
    var options = {
        responsive: true,
        title: {
            display: true,
            position: "top",
            text: "Doughnut Chart",
            fontSize: 18,
            fontColor: "#111"
        },
        legend: {
            display: true,
            position: "bottom",
            labels: {
                fontColor: "#333",
                fontSize: 16
            }
        }
    };

    //create Chart class object
    var chart1 = new Chart(ctx1, {
        type: "doughnut",
        data: data1,
        options: options
    });

    //create Chart class object
    var chart2 = new Chart(ctx2, {
        type: "doughnut",
        data: data2,
        options: options
    });
});
*/
