// Declare the georaster variable at the top level
var georaster;

// Initialize leaflet map
// ------------------ BASE LAYERS -----------------------------------

// OpenStreetMap (already in your code but moved here for clarity)
const osm = L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
  attribution:
    "&copy; <a href='https://www.openstreetmap.org/copyright'>OpenStreetMap</a> contributors",
  zIndex: 0,
});

// ESRI World Imagery with labels
const esriImagery = L.esri.basemapLayer("Imagery").setZIndex(0); // satellite tiles
const esriImageryLbls = L.esri.basemapLayer("ImageryLabels").setZIndex(0); // transparent label overlay
const esriHybrid = L.layerGroup([esriImagery, esriImageryLbls]);

// Put the map on OSM at start
const map = L.map("map", {
  center: [39.057, 34.9116],
  zoom: 7,
  minZoom: 7,
  maxZoom: 12,
  /*maxBounds:[
    [35.808593,25.663883],
    [42.107613,44.822754]
  ],*/
  layers: [osm],
});

// ------------------ LAYER SWITCHER --------------------------------
const baseLayers = {
  OpenStreetMap: osm,
  "ESRI Uydu (Hybrid)": esriHybrid,
};

L.control.layers(baseLayers, null, { position: "topleft" }).addTo(map);

//s

// Parse GeoRaster and add it to the map
var url_to_geotiff_file = "https://d1f1pd1jtui8d5.cloudfront.net/global_vs30_Cnv_Cnv.tif?Expires=1770352905&Signature=OTeiPp2YSmtBml~UGjApV7nH~AY7R8Mi1k8utFG5ojitB4YDVoFO7aul2aeI90xOALYeEVleU3nAKxNn2rRMMrP08sjhjXhD9Zfh22jfoRTtQxYl6O4h9-46-l~aCaWjzfRQFdH0phCyTCHsqZncRH0YRgthqrIXQCT0N~0RKUjzdLGfOemAWxl1-y9rj~XNld5KfokDvPw9wyGmrvg4XCxTu1A-~aZUzj4FFA6uzBUp89olUn6S5MiyPWQKTMwHkp3GsDlP~QR5NWWaqIPokv-ecyC3KmsjOkXg3e6ZZvHDfnMCihJHWtJD0hyH8Y16YMfdoNvwy0gRdtC4dHkXVg__&Key-Pair-Id=K3BYPE7UJNJQVV";
  "https://d1f1pd1jtui8d5.cloudfront.net/global_vs30_Cnv_Cnv.tif?Expires=1747193920&Signature=jOqARst1P58QzSaD86yIPP6X-yHhkYVd8U6I37CwjEkN6WzUnzC7XSzicrutAdQmq74ltHMm~YOuRwJfi435ZlkP6Vprl4mRyekugRcr-e1Ipg-22JiCjP7JnRlbBoY2iDepAblqJCZ4AgUPq-a0Hj43T6Nj9HLfh2zuOOAoMY8QfK0dQBd5uG6wT99k-g1KghLOoLjIhb~~SdO4b8Jcq~gNBACx2G8CgVR1JAQwwZIXX5eml~p7Mh1FT~1rRLQwvwEhWhlIzDxDGGAzkSofHcDXYko-RwVnUoMRjDFP9kqksFcIDVOY-fGiwhJrgePrKk6vTLaV7EhGhA0sM~BYOw__&Key-Pair-Id=K3BYPE7UJNJQVV";
var scaleMinInput = 200;
var scaleMaxInput = 900;

parseGeoraster(url_to_geotiff_file).then((parsedGeoraster) => {
  georaster = parsedGeoraster;

  // Event handler to display pixel value on mouse movement
  map.on("mousemove", function (evt) {
    var latlng = map.mouseEventToLatLng(evt.originalEvent);
    geoblaze
      .identify(georaster, [latlng.lng, latlng.lat])
      .then((pixelValue) => {
        if (pixelValue !== undefined && pixelValue !== null) {
          var roundedPixelValue = Number(pixelValue).toFixed(2);
          var pixelValueElement = document.getElementById("pixelValue");
          pixelValueElement.textContent = "Değer: " + roundedPixelValue;
          pixelValueElement.style.fontWeight = "bold";
        } else {
          document.getElementById("pixelValue").textContent = "";
        }
      });
  });

  // Event handler to hide and then show pixel value box during map updates
  map.on("update", function () {
    var pixelValueBox = document.getElementById("pixelValue");
    pixelValueBox.style.display = "none";
    setTimeout(function () {
      pixelValueBox.style.display = "block";
    }, 0);
  });
  document.getElementById("loader").style.display = "none";
});

var currentOpacity = 0.6; // Default opacity

// Define the function to update the map layer
var georasterLayer = null;

// Function to add or update the raster layer
function addOrUpdateRasterLayer(
  scaleMin,
  scaleMax,
  transparentMin,
  transparentMax
) {
  // Check if layer exists and remove it
  if (georasterLayer) {
    map.removeLayer(georasterLayer);
  }

  // Create and add the new layer with provided settings
  georasterLayer = new GeoRasterLayer({
    georaster: georaster,
    opacity: currentOpacity,
    resolution: 64,
    pixelValuesToColorFn: function (values) {
      var value = values[0];
      if (value < transparentMin || value > transparentMax)
        return "transparent";
      return getColorForValue(value, scaleMin, scaleMax, "Spectral");
    },
    zIndex: 500,
  });
  georasterLayer.addTo(map);
  updateLegend();
}

function getColorForValue(value, scaleMin, scaleMax, scale) {
  var selectedScale = "Spectral";

  return chroma.scale(scale).domain([scaleMin, scaleMax])(value).hex();
}

// Initialize the map with default raster values
parseGeoraster(url_to_geotiff_file).then((parsedGeoraster) => {
  georaster = parsedGeoraster;

  // Default values
  var defaultScaleMin = 180;
  var defaultScaleMax = 900;
  var defaultTransparentMin = 159;
  var defaultTransparentMax = 1500;

  addOrUpdateRasterLayer(
    defaultScaleMin,
    defaultScaleMax,
    defaultTransparentMin,
    defaultTransparentMax
  );
});

// Update map layer function for 'Apply' button

// Event listener for the "Apply" button

var comparisonList = []; // Initialize an empty comparison list

// Function to get the pixel value at a specific location and display in a popup
function displayPixelValue(location, georaster) {
  return new Promise(function (resolve, reject) {
    geoblaze
      .identify(georaster, [location.lng, location.lat])
      .then(function (pixelValue) {
        if (pixelValue !== undefined && pixelValue !== null) {
          var roundedPixelValue = Number(pixelValue).toFixed(2);
          var buttonId =
            "comparison-button-" + location.lat + "-" + location.lng;
          var isInComparison = markerStates[location.toString()];

          var buttonText = isInComparison
            ? "Karşılaştırmadan Çıkar"
            : "Karşılaştırmaya Ekle";
          var buttonOnClick = isInComparison
            ? "removeFromComparison"
            : "addToComparison";

          var popupContent = `
                <span class="pixel-value-text">Değer: ${roundedPixelValue}</span>
                <br>
                <button id="${buttonId}" class="comparison-button" onclick="${buttonOnClick}('${location.toString()}', '${buttonId}')">
                    ${buttonText}
                </button>`;

          resolve(popupContent);
        } else {
          resolve("Pixel value not available");
        }
      })
      .catch(function (error) {
        reject(error);
      });
  });
}

//icon to be switched to when the marker has been added to the comparison
var highlightIcon = new L.Icon({
  iconUrl:
    "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-green.png",
  shadowUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png",
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41],
});

//default icon
var defaultIcon = new L.Icon({
  iconUrl:
    "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-blue.png",
  shadowUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png",
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41],
});

var scatterData = []; // Initialize an empty array for scatter chart data
var markersByLocation = {}; // Object to store markers

var markerStates = {}; // Object to store the state of each marker

// Function to add marker data to comparison list and scatter chart data
function addToComparison(location, buttonId) {
  var button = document.getElementById(buttonId);
  var locationString = location.toString();
  markerStates[location] = true;

  // Find the marker with the specified location
  var markerWithLocation = null;
  for (var i = 0; i < markers.length; i++) {
    var marker = markers[i];
    if (marker.getLatLng().toString() === location) {
      markerWithLocation = marker;
      break;
    }
  }
  markersByLocation[locationString] = marker; // Assuming 'marker' is the marker object

  if (markerWithLocation) {
    // Access the tooltip of the marker and pick the markerCount
    var markerCountFromTooltip = markerWithLocation.getTooltip().getContent();

    // Fetch and display the pixel value in a popup
    displayPixelValue(markerWithLocation.getLatLng(), georaster)
      .then(function (popupContent) {
        var pixelValue = parseFloat(popupContent.split(":")[1].trim()); // Extract the pixel value

        if (!isNaN(pixelValue)) {
          var roundedPixelValue = Number(pixelValue).toFixed(2);

          var item = {
            location: location,
            pixelValue: pixelValue, // Use the actual pixel value
            markerCount: markerCountFromTooltip,
          };

          comparisonList.push(item);

          // Add the new data point to the scatterData array
          scatterData.push({
            x: parseFloat(markerCountFromTooltip),
            y: parseFloat(pixelValue),
            location: locationString, // Use the actual pixel value
          });

          // Update the scatter plot when a point is added
          updateScatterPlot();

          // Update the icon or do other actions with the marker as needed
          markerWithLocation.setIcon(highlightIcon);
        } else {
          console.error("Pixel value not available");
        }
      })
      .catch(function (error) {
        console.error(error);
      });
  } else {
    console.error("Marker not found for location: " + location);
  }
  // At the end of the function, after the marker has been added to the comparison:
  button.textContent = "Karşılaştırmadan Çıkar";
  button.classList.add("remove-from-graph");
  button.onclick = function () {
    removeFromComparison(location, buttonId);
  };
}

function removeFromComparison(location, buttonId) {
  var button = document.getElementById(buttonId);
  var locationString = location.toString();
  delete markerStates[location];

  // Remove the item from the comparisonList
  comparisonList = comparisonList.filter(function (item) {
    return item.location !== locationString;
  });

  // Remove the corresponding data from scatterData
  scatterData = scatterData.filter(function (dataPoint) {
    return dataPoint.location !== locationString;
  });

  // Update the scatter chart
  updateScatterPlot();

  // Revert button text and style
  button.textContent = "Karşılaştırmaya Ekle";
  button.classList.remove("remove-from-graph");

  // Revert button functionality to add to graph
  button.onclick = function () {
    addToComparison(location, buttonId);
  };

  if (markersByLocation[locationString]) {
    markersByLocation[locationString].setIcon(defaultIcon);
    delete markersByLocation[locationString]; // Remove the marker from the object
  }
}

var markers = []; // Initialize an empty array to store markers
var markerCount = 0; // Initialize marker count

// Event handler for adding markers on map click
map.on("click", function (e) {
  var location = e.latlng;
  markerCount++;

  var marker = L.marker(location, {
    markerCount: markerCount,
    title: "Right click to remove marker",
  }).addTo(map);

  marker.on("popupopen", function () {
    displayPixelValue(location, georaster)
      .then(function (popupContent) {
        marker.getPopup().setContent(popupContent);
      })
      .catch(function (error) {
        console.error(error);
      });
  });

  displayPixelValue(location, georaster)
    .then(function (popupContent) {
      marker.bindPopup(popupContent).openPopup();
      marker
        .bindTooltip(String(markerCount), {
          permanent: true,
          offset: [0, 0],
        })
        .openTooltip();
      markers.push(marker);
    })
    .catch(function (error) {
      console.error(error);
    });
});

var userMarker; // Declare a variable to store the user's marker

// Event handler for when the user's location is found
map.on("locationfound", function (e) {
  var userLocation = e.latlng;

  // Remove the previous user marker if it exists
  if (userMarker) {
    userMarker.remove();
  }

  // Create a new marker at the user's location
  userMarker = L.marker(userLocation).addTo(map);
  markerCount++;
  userMarker
    .bindTooltip(String(markerCount), { permanent: true, offset: [0, 0] })
    .openTooltip();

  markers.push(userMarker);
  userMarker.on("popupopen", function () {
    displayPixelValue(userLocation, georaster)
      .then(function (popupContent) {
        userMarker.getPopup().setContent(popupContent);
      })
      .catch(function (error) {
        console.error(error);
      });
  });

  // Fetch and display the pixel value in the marker's popup
  displayPixelValue(userLocation, georaster)
    .then(function (popupContent) {
      userMarker.bindPopup(popupContent).openPopup();

      // Update the pixelValueBox with the popup content
      var pixelValueBox = document.getElementById("pixelValue");
    })
    .catch(function (error) {
      console.error(error);
    });

  // Show the pixelValueBox again after the location is found
  var pixelValueBox = document.getElementById("pixelValue");
  pixelValueBox.style.display = "block";
});

// Add "Find Me" button control
var findMeButton = L.control({
  position: "topleft",
});

findMeButton.onAdd = function (map) {
  var buttonDiv = L.DomUtil.create("div", "find-me-button");
  buttonDiv.innerHTML = 'Beni Bul <i class="fa fa-map-marker"></i>';
  L.DomEvent.addListener(buttonDiv, "click", function () {
    map.locate({
      setView: true,
      maxZoom: 12,
      watch: false, // Disable continuous location updates
    });

    // Hide the pixelValueBox when the button is clicked
    var pixelValueBox = document.getElementById("pixelValue");
    pixelValueBox.style.display = "none";
  });
  L.DomEvent.disableClickPropagation(buttonDiv); // Add this line
  return buttonDiv;
};

findMeButton.addTo(map);

//add an address geocoder button
var geocoder = L.Control.geocoder({ defaultMarkGeocode: false })
  .addTo(map)
  .setPosition("topleft");

// attach and event listenet to address geocoder button
geocoder.on("markgeocode", function (event) {
  var location = event.geocode.center;

  // Center the map on the geocoded location
  map.setView(location, map.getZoom()); // you can also specify a zoom level, e.g., map.setView(location, 10);
  // Create a marker at the geocode result location
  var geocoderMarker = L.marker(location).addTo(map);
  markerCount++;

  geocoderMarker.on("popupopen", function () {
    displayPixelValue(location, georaster)
      .then(function (popupContent) {
        geocoderMarker.getPopup().setContent(popupContent);
      })
      .catch(function (error) {
        console.error(error);
      });
  });

  displayPixelValue(location, georaster)
    .then(function (popupContent) {
      geocoderMarker.bindPopup(popupContent).openPopup();
      geocoderMarker
        .bindTooltip(String(markerCount), {
          permanent: true,
          offset: [0, 0],
        })
        .openTooltip();
      markers.push(geocoderMarker);
    })
    .catch(function (error) {
      console.error(error);
    });
});

// Function to clear all markers and reset their states
function clearAllMarkers() {
  markers.forEach(function (marker) {
    marker.remove();
  });
  markers = [];
  markerStates = {}; // Reset the state of all markers
  comparisonList = []; // Assuming you have a comparison list
  markerCount = 0;
  // Reset any additional state or data structures you might be using
}

//create a button to remove all data from the map and graph
var clearMarkersButton = L.control({ position: "topleft" });
//attach an even listener to clear all markers button
clearMarkersButton.onAdd = function (map) {
  var buttonDiv = L.DomUtil.create("div", "clear-markers-button");
  buttonDiv.innerHTML = 'Noktaları Temizle <i class="fa fa-trash"></i>';
  L.DomEvent.addListener(buttonDiv, "click", function (e) {
    clearAllMarkers();
    // Stop the event from propagating to other elements
    L.DomEvent.stopPropagation(e);

    // Remove all markers from the map
    markers.forEach(function (marker) {
      marker.remove();
    });
    // Clear the markers array
    markers = [];
    comparisonList = [];
    markerCount = 0;

    scatterData = [];
    updateScatterPlot();
  });
  return buttonDiv;
};

clearMarkersButton.addTo(map);

//add a button to remove markers from the map and graph individually with a nearby right click
function removeNearbyMarkers(latlng) {
  const tolerance = 5000;
  const newMarkers = [];
  const removedTooltipValues = new Set(); // Use a Set to store tooltip values for removal

  markers.forEach((marker, index) => {
    const markerLatlng = marker.getLatLng();
    const distance = map.distance(latlng, markerLatlng);

    if (distance >= tolerance) {
      // Only add markers with distance greater than or equal to tolerance to newMarkers
      newMarkers.push(marker);
    } else {
      // Mark the tooltip value for removal
      const tooltipContent = marker.getTooltip().getContent();
      removedTooltipValues.add(tooltipContent);
      // Remove the marker from the map if it's within the tolerance
      marker.remove();
    }
  });

  // Filter scatterData to remove entries corresponding to the removed markers
  scatterData = scatterData.filter(
    (dataPoint) => !removedTooltipValues.has(String(dataPoint.x))
  );

  // Update markers with the filtered array
  markers = newMarkers;

  // Update the scatter plot with the new data
  updateScatterPlot();
}

// add an even listener to remove markers button
map.on("contextmenu", function (e) {
  removeNearbyMarkers(e.latlng);
});

//a function to toggle the side pane
function togglePane() {
  var sidePane = document.getElementById("sidePane");
  var toggleButton = document.getElementById("toggleButton");
  if (sidePane.classList.contains("collapsed")) {
    sidePane.classList.remove("collapsed");
    toggleButton.classList.remove("collapsed");
  } else {
    sidePane.classList.add("collapsed");
    toggleButton.classList.add("collapsed");
  }
}

// Initialize the scatter chart once
var scatterChart;

function initScatterChart() {
  const ctx = document.getElementById("scatterChart").getContext("2d");
  scatterChart = new Chart(ctx, {
    type: "scatter",
    data: {
      datasets: [
        {
          label: "",
          data: [], // Empty data initially
          pointBackgroundColor: "#67aaa3",
          pointBorderColor: "#02434c",
          pointHoverBackgroundColor: "#276e72",
          pointHoverBorderColor: "#0b252d",
          pointRadius: 5,
          pointHoverRadius: 6,
        },
      ],
    },
    options: {
      plugins: {
        legend: {
          display: false, // This will hide the legend
        },
      },
      aspectRatio: 1.5,
      scales: {
        x: {
          type: "linear", // Use linear scale for x-axis (assuming numeric values)
          position: "bottom", // Adjust position as needed
          title: {
            display: true,
            text: "Nokta Sayısı",
          },
          ticks: {
            stepSize: 1, // Set the interval between ticks to 1 (integer values)
            max: Math.ceil(Math.max(...scatterData.map((item) => item.x))), // Set the maximum value
            min: Math.floor(Math.min(...scatterData.map((item) => item.x))), // Set the minimum value
            precision: 0, // Display integers only (no decimal places)
          },
        },
        y: {
          type: "linear", // Use linear scale for y-axis (assuming numeric values)
          position: "left", // Adjust position as needed
          title: {
            display: true,
            text: "Değer",
          },
        },
      },
    },
  });
}

// Call initScatterChart to initialize the scatter chart
initScatterChart();

// Define a function to update the scatter plot
function updateScatterPlot() {
  // Extract x (markerCount) and y (pixelValue) values from the comparisonList

  scatterChart.data.datasets[0].data = scatterData;

  scatterChart.update();

  // Create or update the scatter plot using Chart.js
  const ctx = document.getElementById("scatterChart").getContext("2d");

  if (window.scatterChart) {
    // If the scatterChart object already exists, update its data

    window.scatterChart.data.datasets[0].data = scatterData; // Use scatterData instead of data
    window.scatterChart.update();
  } else {
    // Create a new scatterChart
    window.scatterChart = new Chart(ctx, {
      type: "scatter",
      data: {
        datasets: [
          {
            label: "Markers",
            data: scatterData,
            pointBackgroundColor: ["red", "blue", "green", "orange"], // Customize the point color
            pointRadius: 18, // Customize the point size
          },
        ],
      },
      options: {
        scales: {
          x: {
            title: {
              display: true,
              text: "X-Axis Label", // Customize the x-axis label
            },
          },
          y: {
            title: {
              display: true,
              text: "Y-Axis Label", // Customize the y-axis label
            },
          },
        },
      },
    });
  }
}

// Get references to the transparency control elements
var transparencySlider = document.getElementById("transparencySlider");

// Add an event listener to the slider to control the transparency
transparencySlider.addEventListener("input", function () {
  currentOpacity = transparencySlider.value;
  updateRasterOpacity(currentOpacity);
});

// Function to update the opacity of the raster layer
function updateRasterOpacity(opacity) {
  if (georasterLayer) {
    georasterLayer.setOpacity(opacity);
  }
}

function updateLegend() {
  const legend = document.getElementById("legend");
  const scaleMinValue = 180;
  const scaleMaxValue = 900;
  const steps = 10; // how many colour chips

  // ---------- build HTML ----------
  let html = `<h4>Gösterim (V<sub>S30</sub> Değerleri)</h4>
              <div class="legend-items">`;

  const interval = (scaleMaxValue - scaleMinValue) / steps;
  for (let i = 0; i <= steps; i++) {
    const value = scaleMinValue + i * interval;
    const colour = getColorForValue(
      value,
      scaleMinValue,
      scaleMaxValue,
      "Spectral"
    );

    html += `<div class="legend-item">
                <span class="legend-swatch" style="background:${colour}"></span>
                ${value.toFixed(0)}
              </div>`;
  }
  html += "</div>";

  legend.innerHTML = html;

  /* realign the slider now that the legend’s height may have changed */
  stackSliderAboveLegend();
}

/* ------------------------------------------------------------------ *
 *  Stack the transparency slider directly ABOVE the legend, so the   *
 *  two blocks never overlap – no matter how tall the legend becomes. *
 * ------------------------------------------------------------------ */
function stackSliderAboveLegend() {
  const lg = document.getElementById("legend");
  const sl = document.getElementById("transparencyControl");
  if (!lg || !sl) return;

  // keep the slider's left-edge aligned with legend
  sl.style.left = lg.style.left || "10px";

  // place slider just above legend (10 px gap)
  const gap = 10;
  const legendBottom = parseInt(lg.style.bottom || 10, 10);
  const legendHeight = lg.offsetHeight;
  sl.style.bottom = legendBottom + legendHeight + gap + "px";
}

/* run once on load & resize */
window.addEventListener("load", stackSliderAboveLegend);
window.addEventListener("resize", stackSliderAboveLegend);

/* run again whenever the legend is rebuilt */
const _updateLegend = updateLegend; // keep your existing function
updateLegend = function () {
  _updateLegend.apply(this, arguments); // draw legend as usual
  stackSliderAboveLegend(); // then restack controls
};
