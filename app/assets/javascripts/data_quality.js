//= require jquery
//= require d3-3.5.5.min
//= require spinjs

//Globals
var dataset, fields, orgNest, matrix, opts, target, spinner, sub, asc, req;
                
// Color palette
var color1 = "#156d8d"; // blue for headers
var color2 = "#c15022"; // burnt orange for links
var color3 = "#565a5c"; // dark gray
var color4 = "#aaa"; // medium gray
var color5 = "#589199"; //teal
var color6 = "#b4d707";  // bright green (viz)
var color7 = "#07b4d7";  //bright blue (viz)
var color8 = "#d707b4";   // magenta (viz)
                    
// Fetch the data
$.ajax({ 
    url: '/doc/data/data_quality_by_field.json',
    dataType: 'json',
    success: function(response){
        var format = d3.time.format("%Y-%m-%d");
        //filter the dataset for active only
        dataset = response.filter(function(d) { var today = new Date(); today.setHours(0,0,0,0); return format.parse(d['End Date']) >= today; });
        fields = Object.keys(dataset[0]);
        fieldsToHide = [
            "org_id",
            "date provided",
            "description word count",
            "global"
        ];
        fieldsToShow = fields.filter(function (d) { return fieldsToHide.indexOf(d) == -1; });
        orgNest = d3.nest().key(function(d) { return d.Organization; }).entries(dataset);
        main(); // Once data has loaded, make sure the page has loaded before drawing visuals
        console.log(orgNest);
    },
    error: function(request, status, error){
    console.log('ajax failed with status: ' + status + '. Error: ' + error);
    }
});
                    
// Draw the visuals on page load
function main () {
    $(function() {
        "use strict";
        function scrollTween (offset) {
                        return function () {
                                var i = d3.interpolateNumber(window.pageYOffset || document.documentElement.scrollTop, offset);
                                return function (t) { scrollTo(0, i(t)); };
                        };
        }
        function smoothScroll (targetId) {
                var target = d3.select(targetId);
                d3.transition().duration(1000).tween("scroll", scrollTween($(targetId).offset().top));
        }
        d3.select("#viz1link").on("click", function () {
                smoothScroll("#viz1_anchor");
        });
        d3.select("#viz2link").on("click", function (event) {
                smoothScroll("#viz2_anchor");
        });
        d3.select("#viz3link").on("click", function () {
                smoothScroll("#viz3_anchor");
        });
        visualization1();
        visualization2();
        visualization3();
    
    });
}
                    
function visualization1 () {

    sub = [];
    asc = false;

    // Required fields
    req = [
            "Organization",
            "Project Name",
            "Country",
            "Sector",
            "Start Date",
            "End Date",
            "Description"
    ];

    //COUNT NUMBER OF RECORDS/PROJECTS IN DATASET THAT ARE TRUE/NOT EMPTY
    function count (field) {
        "use strict";
        var c, k, r, p;
        c = 0;

        // Special case for country to count global projects as well (no country assigned)
        if ('Country' === field) {
            
            for (k = 0; k < dataset.length; k++) {
                if ((dataset[k][field] != "" && dataset[k][field] != null) || dataset[k]['global'] === true) {
                    c++;
                }
            }
        } else if (typeof dataset[0][field] === 'boolean') {
            for (k = 0; k < dataset.length; k++) {
                if (dataset[k][field] === true) {
                        c++;
                }
            }
        } else {
            for (k = 0; k < dataset.length; k++) {
                if (dataset[k][field] != "" && dataset[k][field] != null) {
                        c++;
                }
            }
        }
        r = req.indexOf(field);
        p = +(c/dataset.length).toFixed(4);
        return [c, p, field, r];
    }

    //DRAW THE GRAPH
    (function drawGraph () {
        "use strict";
        var w, h, barPadding, leftPadding, rightPadding, topPadding, defaultTickYOffset, header, listWrapper, list, svg, sortBars, xScale, yScale, xAxis, yAxis, i, headerTop, sortItems;
        
        //GRAPH DIMENSIONS
        h = 600;
        leftPadding = 200;
        rightPadding = 20;
        topPadding = 25;
        barPadding = 5;
        w = 645;
        defaultTickYOffset = 9;

        d3.select(".subtitle-project-count-1").html("Based on <b>" + dataset.length + "</b> active projects on NGO Aid Map</span>");
        d3.select(".sort-controls")
            .on("click", function () { d3.selectAll('.sort-options-wrapper').style("display", "block"); });
        sortItems = d3.select(".sort-options-wrapper").selectAll("li")
            .each(function (el, i) {
                d3.select(this).on("click", function () {
                    if (i == 0) { sortBars(1, "asc"); }
                    if (i == 1) { sortBars(1, "desc"); }
                    if (i == 2) { sortBars(2, "asc"); }
                    if (i == 3) { sortBars(2, "desc"); }
                })
            });

        d3.select(".sort-options-close-x")
            .on("click", function () { d3.selectAll('.sort-options-wrapper').style("display", "none");});

            //ARRAY 'SUB' IS A SPECIFIC SLICE OF THE LARGER DATASET
            fieldsToShow.forEach(function (field) {
                sub.push(count(field));
            });

            //SCALE OF AXES
            yScale = d3.scale.ordinal()
                .domain(sub.sort(function (a, b) {
                        return d3.descending(a[0], b[0]);
                })
                .map(function (d) { return d[2]; }))
                .rangeRoundBands([topPadding, h - barPadding]);

            xScale = d3.scale.linear()
                .domain([0, d3.max(sub, function (d) {
                        return d[1];
                })])
                .range([leftPadding, w - rightPadding]);

            //AXES DEFS
            yAxis = d3.svg.axis()
                .scale(yScale)
                .orient("left");
            xAxis = d3.svg.axis()
                .scale(xScale)
                .orient("top")
                .ticks(4)
                .tickFormat(d3.format(".0%"));

            //CHART AREA
            svg = d3.select('#d3_chart').append('svg').attr({
                'width': w,
                'height': h
            });

            //DRAW CHART
            svg.selectAll('rect').data(sub).enter().append('rect').attr({
                "x": leftPadding,
                "y": function (d) { return yScale(d[2]); },
                "width": 0,
                "height": h / (fieldsToShow.length) - barPadding,
                "fill": color7, 
                "class": "dq-bars"
            })
            .on({
                "mouseover": function (d) {
                    // Tooltip
                    tooltipShow("#d3_bar_tt");
                    d3.select("#d3_bar_tt")
                        .html("<div>" + d[2] + "</div><div>Provided for <strong>" + +(d[1] * 100).toFixed() + "%</strong> of projects</div><div>" + d[0] + " Projects")
                        .style("left", (d3.event.pageX + 10) + "px").style("top", (d3.event.pageY - 50) + "px");
                },
                "mouseout": function (d) {
                    tooltipHide("#d3_bar_tt");
                }
            });

            //Animate bar width on initial load
            svg.selectAll("rect.dq-bars").transition().attr("width", function (d) {
                return xScale(d[1]) - leftPadding;
            }).duration(1000);

            //ADD THE AXES DEFINED EARLIER
            svg.append("g").data(sub)
                .attr("class", "y axis")
                .attr("transform", function () { return "translate(9,0)"; }) // offset the "-9" text offset default in the axis
                .call(yAxis)
                .selectAll("text").each(function (d) {
                    if (req.indexOf(d) !== -1) {
                    
                        if (d === 'Country') {
                            $(this).html(d + "*&#8224;");
                        } else {
                            d3.select(this).text(d + "*");
                        }
                    }
                });
            
            svg.append("g").data(sub)
                .attr("class", "x axis")
                .attr("transform", function () { return "translate(0, " + topPadding + ")"; })
                .call(xAxis);
                    
            
            sortBars = function (field, dir) {
                var yScale0, transition;
                    
                yScale0 = yScale.domain(sub.sort(dir == "asc"
                    ? field === 1 // if sorting by name ascending
                        ? function (a, b) {
                            if (a[2] > b[2]) { return 1; }
                            if (a[2] < b[2]) { return -1; }
                            return 0;
                        }
                        : function (a, b) { // if sorting by value ascending
                            return d3.ascending(a[0], b[0]);
                        }
                : field === 1 // if sorting by name descending
                        ? function (a, b) {
                            if (a[2] < b[2]) { return 1; }
                            if (a[2] > b[2]) { return -1; }
                            return 0;
                        } 
                        : function (a, b) { // if sorting by value descending
                            return d3.descending(a[0], b[0]);
                        })
                        .map(function (d) { return d[2]; }))
                        .copy();

                transition = svg.transition().duration(1000);
                transition.selectAll("rect").attr("y", function (d) { return yScale0(d[2]); });
                transition.select(".y.axis").call(yAxis).attr({"x": 15})
                    .selectAll("text").each(function (d) {
                        if (req.indexOf(d) !== -1) {
                            if (d === 'Country') {
                                $(this).html(d + "*&#8224;");
                            } else {
                                d3.select(this).text(d + "*");
                            }
                        }
                    });
                                    
                //SWITCH THE SORT TOGGLER
                if (!asc) {
                    asc = true;
                } else {
                    asc = false;
                }
            };
            // Add the tooltip element
            d3.select("body").append("div").attr({"id": "d3_bar_tt", "class": "d3-tt tt-y"});
            
    })(); // End drawGraph
        
} // End visualization 1
                    
function visualization2 () {
        
    (function setSpinOpts () {
        // BUSY SPINNER
        opts = {
            lines: 9, // The number of lines to draw
            length: 0, // The length of each line
            width: 10, // The line thickness
            radius: 15, // The radius of the inner circle
            corners: 1, // Corner roundness (0..1)
            rotate: 0, // The rotation offset
            direction: 1, // 1: clockwise, -1: counterclockwise
            color: '#000', // #rgb or #rrggbb or array of colors
            speed: 1, // Rounds per second
            trail: 60, // Afterglow percentage
            shadow: false, // Whether to render a shadow
            hwaccel: false, // Whether to use hardware acceleration
            className: 'spinner', // The CSS class to assign to the spinner
            zIndex: 2e9, // The z-index (defaults to 2000000000)
            top: '50%', // Top position relative to parent
            left: '50%', // Left position relative to parent
            position: "fixed"
        };
        target = document.getElementsByTagName("body")[0];
        spinner = new Spinner(opts);
    })();
        
    function spin (s) {
        if (!s) {
                spinner.stop(target);
        } else {
                spinner.spin(target);
        }
    }
        
    function calculateCompleteness (org, field) {
        var projects, c, k, result;
        
        projects = orgNest.filter(function(o){ return o.key == org; })[0].values; //Filter for this organization, return array of values (projects)
        c = 0;
        if (typeof projects[0][field] === 'boolean') {
            for(k = 0; k < projects.length; k++){
                if (projects[k][field] === true) {
                        c++;
                }
            }
        } else {
            for (k = 0; k < projects.length; k++){
                if (projects[k][field] !== "" && projects[k][field] !== null) {
                        c++;
                }
            }
        }
        result = (c / projects.length).toFixed(4);
        return +result;
    }        

    (function drawGraph(){
        var i, m, p, h, w, leftPad, rightPad, bottomPad, topPad, h2, yScale, yScale0, xScale, yAxis, xAxis, svg, sortField, completeness, group1color, group2color, group3color, axisColor, axisColorSorted, pieData, ul, li, li2, li3, group1text, group2text, group3text, group1thresh, group2thresh;

        w = 645;
        leftPad = 275;
        rightPad = 20;
        bottomPad = 20;
        topPad = 180;
        h2 = 20 * orgNest.length;
        group1color = color6;
        group2color = color7;
        group3color = color4; //"rgb(170,170,170)";
        group1thresh = 0.75;
        group2thresh = 0.50;
        axisColor = color3; //"#999";
        axisColorSorted = color8;
        group1text = "Always/Usually Provided";
        group2text = "Often Provided";
        group3text = "Rarely/Never Provided";
        
        // Matrix of circle data and coordinates
        matrix = [];
        for(m=0; m<orgNest.length; m++){
        
            fieldsToShow.forEach(function (field) {
                completeness = calculateCompleteness(orgNest[m].key, field);
                matrix.push({
                    "org": orgNest[m].key,
                    "field": field,
                    "completeness": completeness,
                    "group": completeness >= 0.75 ? group1text : completeness >= 0.50 ? group2text : group3text
                });
            });
        }
        
        // SCALES
        yScale = d3.scale.ordinal().domain(orgNest.sort(function (a, b) {
            if (a.key > b.key) { return 1; }
            if (a.key < b.key) { return -1; }
            return 0;
        })
        .map(function (d) { return d.key; }))
        .rangePoints([topPad, h2 - bottomPad]);
        
        xScale = d3.scale.ordinal().domain(fieldsToShow)
            .rangePoints([leftPad, w - rightPad]);
        
        // AXES
        yAxis = d3.svg.axis().scale(yScale).orient("left");
        xAxis = d3.svg.axis().scale(xScale).orient("top");
            
        // SHAPES
        svg = d3.select('#d3_dq_matrix').append('svg').attr({
            "height": h2,
            "width": w,
            "class": "chart"
        });

        // DRAW ALL THE CIRCLES
        svg.selectAll("circle.matrix-circle").data(matrix).enter().append("circle").attr({
            "cx": function(d, i){ return xScale(d.field); },
            "cy": function(d, i){ return yScale(d.org); },
            "r": function(d) { return d.completeness >= group1thresh ? 2.5 : d.completeness >= group2thresh ? 2.5 : 2.5; },
            "stroke": function(d) { return d.completeness >= group1thresh ? group1color : d.completeness >= group2thresh ? group2color : group3color; },
            "stroke-width": 10,
            "stroke-opacity": 0,
            "fill": function(d) { return d.completeness >= group1thresh ? group1color : d.completeness >= group2thresh ? group2color : group3color; }, 
            "fill-opacity": 1,
            "class": "matrix-circle"
        })
        .on({
            "mouseover": function (d, i) { 
                var color, text;
                
                color = d.completeness >= group1thresh ? group1color : d.completeness >= group2thresh ? group2color : group3color;
                text = "<div class=\"tt-dot-header\">" + d.org + "</div><div class=\"tt-dot-body\">" + d.field + "<div style=\"margin-top: 5px; color:" + color + ";\">" + d.group + "</div></div>";
                
                d3.select(this).transition().ease("linear").attr("r", 6);
                d3.select("#d3_dot_tooltip").transition().duration(250).style("opacity", 0.95);
                d3.select("#d3_dot_tooltip").html(text).style("left", (d3.event.pageX + 10) + "px").style("top", (d3.event.pageY - 50) + "px");
            },
            "mouseout": function (d) {
                d3.select(this).transition().duration(500).ease("linear").attr("r", 2.5);
                d3.select("#d3_dot_tooltip").transition().duration(500).style("opacity", 0);
            }
        });

        // x Axis
        svg.append("g").data(matrix).attr({
                "transform": function(){ return "translate(0,"+ topPad +")"; },
                "class": "x axis"
        })
        .call(xAxis)
        .selectAll("text")
        .attr({
            "transform": "rotate(270)",
            "style": "text-anchor: start",
            "x": 15,
            "y": 4
        })
        .each(function (d) {
            if (req.indexOf(d) !== -1) {
            
                if (d === 'Country') {
                    $(this).html(d + "*&#8224;");
                } else {
                    d3.select(this).text(d + "*");
                }
            }
        })
        .on({
            "mouseover": function (d) { 
                var g1count, g2count, g3count, text;
                
                d3.selectAll("circle.matrix-circle")
                    .filter(function(a) { return a.field == d; })
                    .transition().ease("linear").attr("r", 6);
                        
                // Count the number of organizations in each group
                g1count = matrix.filter(function (a) { return a.field == d; }).filter(function (a) { return a.completeness >= group1thresh; }).length;
                g2count = matrix.filter(function (a) { return a.field == d; }).filter(function (a) { return a.completeness >= group2thresh && a.completeness < group1thresh; }).length;
                g3count = orgNest.length - g1count - g2count;
                text = "<div class=\"tt-x-title\">" + d + "</div><p>(Click to sort)</p><p id=\"d3_x_tt_g1\"><span>" + g1count + "</span></p><p id=\"d3_x_tt_g2\"><span>" + g2count + "<span></p><p id=\"d3_x_tt_g3\"><span>" + g3count + "</span></p>";
                
                // Populate the popup
                d3.select("#d3_x_tooltip").transition().duration(250).style("opacity", 0.9);
                d3.select("#d3_x_tooltip").html(text).style("left", (d3.event.pageX + 15) + "px").style("top", (d3.event.pageY - 20) + "px");
                d3.select("#d3_x_tt_g1").insert("svg", ":first-child").attr({"height": "1em", "width": "1em"}).append("circle").attr({"cx": "0.5em", "cy": "0.5em", "r": 6, "fill": group1color});
                d3.select("#d3_x_tt_g2").insert("svg", ":first-child").attr({"height": "1em", "width": "1em"}).append("circle").attr({"cx": "0.5em", "cy": "0.5em", "r": 6, "fill": group2color});
                d3.select("#d3_x_tt_g3").insert("svg", ":first-child").attr({"height": "1em", "width": "1em"}).append("circle").attr({"cx": "0.5em", "cy": "0.5em", "r": 6, "fill": group3color});
            },
            "mouseout": function (d) {
                d3.selectAll("circle.matrix-circle")
                    .filter(function (b) { return b.field == d; })
                    .transition().duration(500).ease("linear").attr("r", 2.5);
                // tooltip    
                d3.select("#d3_x_tooltip").transition().duration(500).style("opacity", 0);
            },
            "click": function (d) {
                spin(true);
                setTimeout(function() { sortField(d); }, 500);
            }
        });
            
        // y Axis
        svg.append("g").data(matrix).attr({
            "transform": function(){ return "translate(" + leftPad + ",0)"; }, // test layout
            "class": "y axis"
        })
        .call(yAxis)
        .selectAll("text")
        .attr("x", -15)
        .on({
            "mouseover": function (d, i) { 
                d3.selectAll("circle.matrix-circle")
                    .filter(function(a) { return a.org == d; })
                    .transition().ease("linear").attr("r", 6);
                        
                // tooltip
                d3.select("#d3_y_tooltip").transition().delay(500).duration(250).style("opacity", 0.95);
                d3.select("#d3_y_tooltip").html("Show Summary").style("left", (d3.event.pageX - 120) + "px").style("top", (d3.event.pageY - 40) + "px");
            },
            "mouseout": function (d) {
                d3.selectAll("circle.matrix-circle")
                    .filter(function (a) { return a.org == d; })
                    .transition().duration(500).ease("linear").attr("r", 2.5);
                        
                //tooltip
                d3.select("#d3_y_tooltip").transition().duration(500).style("opacity", 0);
            },
            "click": function(d) {
                var modHgt, project_num, group1, group2, group3;
                
                //Clear the previous list
                d3.select(".d3-org-modal-div-right").selectAll("li").remove();
                
                // Position the organization modal window
                modHgt = 400;
                d3.select("#d3_org_modal").style("display", "block").transition().duration(500).style("opacity", 1);
                d3.select(".d3-org-modal-div").style("margin-top", (window.innerHeight - modHgt) / 2 + "px").style("height", modHgt + "px");
                
                // If available height is limited, move the close button down
                if ((window.innerHeight - modHgt) / 2 < 60) {
                        d3.select(".d3-org-modal-close").style("top", 0);
                } else { d3.select(".d3-org-modal-close").style("top", "-50px"); }
                            
                //Populate the data
                project_num = orgNest.filter(function(o){ return o.key == d; })[0].values.length;
                group1 = matrix.filter(function (a) { return a.org == d; }).filter(function (b) { return b.completeness >= group1thresh; });
                group2 = matrix.filter(function (a) { return a.org == d; }).filter(function (b) { return b.completeness >= group2thresh && b.completeness < group1thresh; });
                group3 = matrix.filter(function (a) { return a.org == d; }).filter(function (b) { return b.completeness < group2thresh; });
                            
                // Title data
                d3.select(".d3-org-modal-div-left-name").html(d)
                    // info popup
                    .append("div").attr("class", "d3-org-modal-div-left-name-info")
                    .on({
                        "mouseover": function () {
                            var id, infoText;
                            id = dataset.filter(function (a) { return a.Organization == d; })[0].org_id;  // Grab the id from the first record matching the selected organization
                            infoText = "<div style=\"font-size: 0.9em; color: #aaa; margin: 0 0 10px 0\">Data calculated from:</div><a href=\"//www.ngoaidmap.org/organizations/" + id + "\" target=\"_blank\">" + project_num + " active project(s)</a> on NGO Aid Map<br>by " + d + "<p class=\"tt-info-footer\">Note: Not all fields are applicable for all organizations. Data for certain fields may also not be provided due to privacy, security, or other concerns.</p><p class=\"tt-info-footer\">* Field is required for all projects.<br>&#8224; Includes projects that are global in scope.</p></div>";
                                                        
                            d3.select("#d3_info_tooltip").style("display", "block").html(infoText).style("top", 0).style("right", 220 + "px").transition().duration(250).style("opacity", 1);
                        },
                        "mouseout": function () {
                            tooltipHide("#d3_info_tooltip");
                        }
                    })
                    .html("i");
                    
                // Print the list for the right side
                for (i = 0; i < group1.length; i++) {
                    d3.select(".d3-org-modal-div-right")
                    .append("li")
                    .html(function () {
                        var d = group1[i].field;
                        if (req.indexOf(d) !== -1) {
                        
                            if (d === 'Country') {
                                    return d + "*&#8224;";
                            } else {
                                    return d + "*";
                            }
                        }
                        return d;
                    })
                    .style("color", group1color);
                }
                for (i = 0; i < group2.length; i++) {
                    d3.select(".d3-org-modal-div-right").append("li").html(group2[i].field).style("color", group2color);
                }
                for (i = 0; i < group3.length; i++) {
                    d3.select(".d3-org-modal-div-right").append("li").html(group3[i].field).style("color", group3color);
                }
                // Divide the lines up evenly from the available height, but shorten by two because org_id and date provided are not included
                d3.selectAll(".d3-org-modal-div-right li").style("height", (modHgt / fieldsToShow.length) + "px");
                
                // Print the counts for each category
                d3.select("#legend1").style("color", group1color).html(group1.length);
                d3.select("#legend2").style("color", group2color).html(group2.length);
                d3.select("#legend3").style("color", group3color).html(group3.length);
                    
                // Generate the pie chart
                pieData = [group1.length, group2.length, group3.length];
                (function (values) {
                    var groups, width, height, radius, color, arc, pie, exists, svg, g;
                    
                    groups = [group1text, group2text, group3text];
                    width = 260;
                    height = 260;
                    radius = 110;
                    color = d3.scale.ordinal().domain(groups).range([group1color, group2color, group3color]);
                    arc = d3.svg.arc().outerRadius(radius - 10).innerRadius(radius - 70);
                    pie = d3.layout.pie().sort(null).value(function (d) { return d; });
                    exists = d3.select(".d3-org-modal-div-left-graph").select("svg");
                    
                    if (exists) { exists.remove(); }
                    
                    svg = d3.select(".d3-org-modal-div-left-graph").append("svg").attr({
                        "width": width,
                        "height": height
                        })
                    .append("g")
                    .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");
                            
                    g = svg.selectAll(".arc")
                        .data(pie(values))
                        .enter().append("g")
                        .attr("class", "arc");
                    
                    g.append("path").attr("d", arc).style("fill", function (d, i) { return color(groups[i]); });
                            
                })(pieData);
            }
        });
                    
        // Mouseovers for the organization modal info pop up
        d3.select("#d3_info_tooltip")
                .on("mouseover", function () {
                                d3.select(this).transition().style("opacity", 1);
                })
                .on("mouseout", function () {
                                tooltipHide("#d3_info_tooltip");
        });
                    
        // Sort function for y-axis
        sortField = function (field) {
            var transition;
            yScale0 = yScale.domain(orgNest.sort(function (a, b) {
                var x1, x2, y1, y2;
                x1 = matrix.filter(function(s){ return s.org == a.key; } ).filter(function(t){ return t.field == field; })[0].group;
                x2 = matrix.filter(function(s){ return s.org == b.key; } ).filter(function(t){ return t.field == field; })[0].group;
                
                y1 = a.key;
                y2 = b.key;
                
                if (x1 != x2) {
                        if (x1 < x2) return -1;
                        if (x1 > x2) return 1;
                        return 0;
                }
                if (y1 < y2) return -1;
                if (y1 > y2) return 1;
                return 0;
            }).map(function (d) { return d.key; }))
            .copy();
                                                            
            // Update the y axis order
            yAxis.scale(yScale0);
            
            // Clear previous stroke widths
            d3.selectAll("circle.matrix-circle").attr({
                "stroke-width": 10,
                "stroke-opacity": 0
            });
                                    
            // Transition the y-axis and circle positions
            transition = svg.transition().duration(1000);
            transition.select(".y.axis").call(yAxis).selectAll("text").attr({"x": -15});
            transition.selectAll("circle.matrix-circle").attr({
                "cx": function(d, i){ return xScale(d.field); },
                "cy": function(d, i){ return yScale0(d.org); },
            }).filter(function (a) {
                return a.field == field;
            }).attr({
                "stroke-width": 4,
                "stroke-opacity": 1
            });
            
            // Clear previous underlines
            svg.select(".x.axis").selectAll("text").style("fill", axisColor);
                    
            // Mark the sorted field
            transition.selectAll("text").filter(function(d) { return d == field; }).style("fill", axisColorSorted);
            
            transition.selectAll("circle.matrix-circle").attr({"fill-opacity": 1});
            
            //Turn off the spinner
            spin(false);
        };
            
        // Set up modal closer
        d3.select(".d3-org-modal-close").on("click", function () {
                tooltipHide("#d3_org_modal");
        });
        
        // Draw the legend
        ul = d3.select("#d3_matrix_legend").append("ul");
        li = ul.append("li");
            li.append("svg").attr({"height": "1em", "width": "1em"}).append("circle").attr({"cx": "0.5em", "cy": "0.5em", "r": 6, "fill": group1color});
            li.append("span").html(group1text);
        li2 = ul.append("li");
            li2.append("svg").attr({"height": "1em", "width": "1em"}).append("circle").attr({"cx": "0.5em", "cy": "0.5em", "r": 6, "fill": group2color});
            li2.append("span").html(group2text);
        li3 = ul.append("li");
            li3.append("svg").attr({"height": "1em", "width": "1em"}).append("circle").attr({"cx": "0.5em", "cy": "0.5em", "r": 6, "fill": group3color});
            li3.append("span").html(group3text);
        
        //Create the tooltip elements
        d3.select("body").append("div").attr("id", "d3_dot_tooltip").attr("class", "d3-tt tt-dot");
        d3.select("body").append("div").attr("id", "d3_x_tooltip").attr("class", "d3-tt tt-x");
        d3.select("body").append("div").attr("id", "d3_y_tooltip").attr("class", "d3-tt tt-y");
            
    })(); // end drawGraph
} // End visualization 2
                    
function visualization3 () {

    function calculateTimeliness (org) {
        var arr, projects, c, k, format, f1, f2, result, dateProvided, cutoffDate, h, w, leftPad, rightPad, svg, scores, i, org, scoresMax, scoresMin, scoresMean, data, labels, xScale, yScale, yAxis, score, colorBest, colorAvg, colorWorst, unit, text;
        
        arr = [];
        f1 = "date provided";
        f2 = "Start Date";
        cutoffDate = new Date(2014, 0, 1);
        format = d3.time.format("%Y-%m-%d");
        projects = orgNest.filter(function(o){ return o.key == org; })[0].values; //Filter for this organization, return array of values (projects)
        c = 0;
        // Loop through all the projects
        for (k = 0; k < projects.length; k++){
            // FILTER ONLY FOR PROJECTS STARTING 2014 OR LATER!
            if (format.parse(projects[k][f2]) >= cutoffDate) {
            
                if (projects[k][f1] !== "" && projects[k][f1] !== null) { // screen out any non-date values for date provided
                    dateProvided = format.parse(projects[k][f1]);
                    dateStart = format.parse(projects[k][f2]);
                    timeliness = (dateProvided - dateStart) / 1000 / 60 / 60 / 24; // convert back up from milliseconds to days
                    arr.push(timeliness);
                }
            }	
        }
        if (arr.length) return d3.mean(arr);
    } 
        
    scores = [];  // array to hold each organization's average timeliness
    for (i = 0; i < orgNest.length; i++) {
        org = orgNest[i].key;
        score = calculateTimeliness(org);
        if (score >= 0) { scores.push(score); }
            
    }
    scoresMax = +(d3.max(scores).toFixed());
    scoresMin = +(d3.min(scores).toFixed());
    scoresMean = +(d3.mean(scores).toFixed());
    
    data = [scoresMin, scoresMean, scoresMax];
    labels = ["Most Timely", "Average", "Least Timely"];
    
    h = 150;
    w = 645;
    leftPad = 125;
    rightPad = 85;
    colorBest = color6;
    colorAvg = color7;
    colorWorst = color4; //"#fbff7f";
    
    xScale = d3.scale.linear().domain([0, d3.max(data)])
        .range([leftPad, w - rightPad]);
    
    yScale = d3.scale.ordinal().domain(labels)
        .rangeRoundBands([0, h], 0.10);
    
    yAxis = d3.svg.axis().scale(yScale).orient("left");
    
    svg = d3.select("#d3_timeliness").append("svg").attr({
        "height": h,
        "width": w
    });
    
    svg.selectAll("rect").data(data).enter().append("rect").attr({
        "x": leftPad,
        "y": function (d, i) { return yScale(labels[i]); },
        "height": yScale.rangeBand(),
        "width": function (d) { return xScale(d) - leftPad; },
        "fill": function (d, i) { return i == 0 ? colorBest : i == 1 ? colorAvg : colorWorst; }
    })
    .on({
        "mouseover": function (d, i) {
            text = i == 0 ? "The most timely"
                : i == 1 ? "A typical"
                : "The least timely";
            unit = d == 1 ? "day" : "days";
            tooltipShow("#d3_time_tt");
            d3.select("#d3_time_tt")
                .html(text + " organization provides information on a project roughly <strong>" + d + " days</strong> after its start date")
                .style("left", (d3.event.pageX + 10) + "px").style("top", (d3.event.pageY - 50) + "px");
        },
        "mouseout": function (d) {
            tooltipHide("#d3_time_tt");
        }
    });
    
    svg.selectAll("text.label").data(data).enter().append("text")
        .text(function (d) { return d + " days"; }).attr({
            "x": w,
            "y": function (d, i) { return yScale(labels[i]) + yScale.rangeBand() / 2 +  8; },
            "class": "time-label"
        }).style("text-anchor", "end").style("font-size", 16);

    svg.append("g").data(data).attr({
        "class": "y axis",
        "transform": function () { return "translate(" + leftPad + ", 0)"; }
    })
    .call(yAxis);
    
    d3.select("body").append("div").attr({"id": "d3_time_tt", "class": "d3-tt tt-time"});
        
} // End Viz 3

function tooltipShow(id) {
    d3.select(id).style("display", "block");
    d3.select(id).transition().duration(250).style("opacity", 0.95);
}
function tooltipHide(id) {
    d3.select(id).transition().duration(500).style("opacity", 0);
    d3.select(id).transition().delay(500).style("display", "none");
}