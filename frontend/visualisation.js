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

var txt = document.querySelector("p");

function updateBtn1() {
    if(btn1.value === "select"){
        /*btn1.style.backgroundColor = 'lightgray';
        btn1.style.color = 'black';
        btn1.value = "not-select"

        btn2.style.backgroundColor = 'blue';
        btn2.style.color = 'white';
        btn2.value = "select"*/
        if (map.getAttribute('data-status') === 'hidden') {
            map.style.display = 'block';
            map.setAttribute('data-status', 'visible');
            console.log("La div est maintenant visible.");
        } else {
            map.style.display = 'none';
            map.setAttribute('data-status', 'hidden');
            console.log("La div est maintenant cachée.");
        }

        if (tab.getAttribute('data-status') === 'hidden') {
            tab.style.display = 'block';
            tab.setAttribute('data-status', 'visible');
            console.log("La div est maintenant visible.");
        } else {
            tab.style.display = 'none';
            tab.setAttribute('data-status', 'hidden');
            console.log("La div est maintenant cachée.");
        }
    }
    else{
        console.log("btn1");
        btn1.style.backgroundColor = 'blue';
        btn1.style.color = 'white';
        btn1.value = "select"

        btn2.style.backgroundColor = 'lightgray';
        btn2.style.color = 'black';
        btn2.value = "not-select"

        if (map.getAttribute('data-status') === 'hidden') {
            map.style.display = 'block';
            map.setAttribute('data-status', 'visible');
            console.log("La div est maintenant visible.");
        } else {
            map.style.display = 'none';
            map.setAttribute('data-status', 'hidden');
            console.log("La div est maintenant cachée.");
        }

        if (tab.getAttribute('data-status') === 'hidden') {
            tab.style.display = 'block';
            tab.setAttribute('data-status', 'visible');
            console.log("La div est maintenant visible.");
        } else {
            tab.style.display = 'none';
            tab.setAttribute('data-status', 'hidden');
            console.log("La div est maintenant cachée.");
        }
    }

}
function updateBtn2() {
    if(btn2.value === "select"){
        /*btn2.style.backgroundColor = 'lightgray';
        btn2.style.color = 'black';
        btn2.value = "not-select"

        btn1.style.backgroundColor = 'blue';
        btn1.style.color = 'white';
        btn1.value = "select"*/
        if (map.getAttribute('data-status') === 'hidden') {
            map.style.display = 'block';
            map.setAttribute('data-status', 'visible');
            console.log("La div est maintenant visible.");
        } else {
            map.style.display = 'none';
            map.setAttribute('data-status', 'hidden');
            console.log("La div est maintenant cachée.");
        }

        if (tab.getAttribute('data-status') === 'hidden') {
            tab.style.display = 'block';
            tab.setAttribute('data-status', 'visible');
            console.log("La div est maintenant visible.");
        } else {
            tab.style.display = 'none';
            tab.setAttribute('data-status', 'hidden');
            console.log("La div est maintenant cachée.");
        }
    }
    else{
        btn2.style.backgroundColor = 'blue';
        btn2.style.color = 'white';
        btn2.value = "select"

        btn1.style.backgroundColor = 'lightgray';
        btn1.style.color = 'black';
        btn1.value = "not-select"
        if (map.getAttribute('data-status') === 'hidden') {
            map.style.display = 'block';
            map.setAttribute('data-status', 'visible');
            console.log("La div est maintenant visible.");
        } else {
            map.style.display = 'none';
            map.setAttribute('data-status', 'hidden');
            console.log("La div est maintenant cachée.");
        }

        if (tab.getAttribute('data-status') === 'hidden') {
            tab.style.display = 'block';
            tab.setAttribute('data-status', 'visible');
            console.log("La div est maintenant visible.");
        } else {
            tab.style.display = 'none';
            tab.setAttribute('data-status', 'hidden');
            console.log("La div est maintenant cachée.");
        }
    }
}




 