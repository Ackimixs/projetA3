d3.csv(
	"https://raw.githubusercontent.com/plotly/datasets/master/2015_06_30_precipitation.csv",
	function(err, rows) {
		function unpack(rows, key) {
			return rows.map(function(row) {
				return row[key];
			});
		}

		let data = [
			{
				type: "scattermapbox",
				text: unpack(rows, "Globvalue"),
				lon: unpack(rows, "Lon"),
				lat: unpack(rows, "Lat"),
				marker: { color: "bleue", size: 4 }
			}
		];

		let layout = {
			dragmode: "zoom",
			mapbox: { style: "open-street-map", center: { lat: 38, lon: -90 }, zoom: 3 },
			margin: { r: 10, t: 30, b: 30, l: 10 }
        
		};

		Plotly.newPlot("simple-visualisation", data, layout);
	}
);



var btn1 = document.getElementById('btn-choise-map');
var btn2 = document.getElementById('btn-choise-tab');
var map = document.getElementById('simple-visualisation');
var tab = document.getElementById('simple-tab');


btn1.addEventListener("click", updateBtn1);
btn2.addEventListener("click", updateBtn2);

btn1.addEventListener("click", changemaptab);
btn2.addEventListener("click", changemaptab);

function updateBtn1() {
    if(btn1.value === "select"){

    }
    else{
        btn1.style.backgroundColor = '#C38D9E';
        btn1.style.color = 'white';
        btn1.value = "select"
        map.setAttribute('data-status', 'visible');
        tab.setAttribute('data-status', 'hidden');

        btn2.style.backgroundColor = 'lightgray';
        btn2.style.color = 'black';
        btn2.value = "not-select"

    }

}
function updateBtn2() {
    if(btn2.value === "select"){

    }
    else{
        btn2.style.backgroundColor ='#C38D9E';
        btn2.style.color = 'white';
        btn2.value = "select"
        tab.setAttribute('data-status', 'visible');
        map.setAttribute('data-status', 'hidden');

        btn1.style.backgroundColor = 'lightgray';
        btn1.style.color = 'black';
        btn1.value = "not-select"

    }
}

function changemaptab(){
    if (map.getAttribute('data-status') === 'visible'){
        map.style.display = 'block';
        tab.style.display = 'none';
    }
    else{
        map.style.display = 'none';
        tab.style.display = 'block';
    }
}




 