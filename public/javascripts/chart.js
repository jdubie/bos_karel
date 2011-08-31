function start(message) {
  var n = 2, // number of layers
      m = 5, // number of samples per layer

      startTime = Date.now(),

      // data = [[],[]],

      data = d3.layout.stack().offset("zero")([[{x:0,y:0},{x:message.period,y:0}],[{x:0,y:0},{x:message.period,y:0}]]),

      color = d3.interpolateRgb("#aad", "#556"),

      w = message.w,
      h = message.h,
      mx = message.period,
      my = message.my
      period = message.period;

  // var w = data.w,
  //     h = 500,
  //     mx = m - 1,
  //     my = d3.max(data, function(d) {
  //       return d3.max(d, function(d) {
  //         return d.y0 + d.y;
  //       });
  //     });

  // data = d3.layout.stack().offset("zero")([ [ {x:0,y:1},{x:1,y:2} ] ,[ {x:0,y:1},{x:1,y:3} ] ] ),


  var area = d3.svg.area()
      .x(function(d) { return d.x * w / mx; })
      .y0(function(d) { return h - d.y0 * h / my; })
      .y1(function(d) { return h - (d.y + d.y0) * h / my; });

  var vis = d3.select("#chart")
    .append("svg:svg")
      .attr("width", w)
      .attr("height", h);

  vis.selectAll("path")
      .data(data)
    .enter().append("svg:path")
      .style("fill", function() { return color(Math.random()); })
      .attr("d", area);

  function transition(msg) {
    d3.selectAll("path")
        .data(function() {


          if (data[0].length > period) {
            data[0].shift();
            data[1].shift();
            console.log('shifting')
          }

          for (i = 0; i < data[0].length; i++) {
            data[0][i].x = data[0][i].x - 1;
            data[1][i].x = data[1][i].x - 1;
          }

          x = period - 1;

          a = d3.layout.stack().offset("zero")([ [{x:x, y:msg.iphone}], [{x:x, y:msg.web}] ])

          data[0].push(a[0][0]);
          data[1].push(a[1][0])


          // modify area
          // mx = data[0].length - 1
          // my = 2

          // if (mx == 0) {
          //   mx == 1;
          // }

          return data;
        })
      .transition()
        .duration(1)
        .attr("d", area);
  }

// var n = 4, // number of layers
//     m = 64, // number of samples per layer
//     data = d3.layout.stack().offset("zero")([[{x:0,y:0},{x:message.period,y:0}],[{x:0,y:0},{x:message.period,y:0}]]),
//     // data = d3.layout.stack()(stream_layers(n, m, .1)),
//     color = d3.interpolateRgb("#aad", "#556");

// var p = 20,
//     w = 960,
//     h = 500 - .5 - p,
//     mx = m,
//     my = d3.max(data, function(d) {
//       return d3.max(d, function(d) {
//         return d.y0 + d.y;
//       });
//     }),
//     mz = d3.max(data, function(d) {
//       return d3.max(d, function(d) {
//         return d.y;
//       });
//     }),
//     x = function(d) { return d.x * w / mx; },
//     y0 = function(d) { return h - d.y0 * h / my; },
//     y1 = function(d) { return h - (d.y + d.y0) * h / my; },
//     y2 = function(d) { return d.y * h / mz; }; // or `my` to not rescale

// var vis = d3.select("#chart")
//   .append("svg:svg")
//     .attr("width", w)
//     .attr("height", h + p);

// var layers = vis.selectAll("g.layer")
//     .data(data)
//   .enter().append("svg:g")
//     .style("fill", function(d, i) { return color(i / (n - 1)); })
//     .attr("class", "layer");

// var bars = layers.selectAll("g.bar")
//     .data(function(d) { return d; })
//   .enter().append("svg:g")
//     .attr("class", "bar")
//     .attr("transform", function(d) { return "translate(" + x(d) + ",0)"; });

// bars.append("svg:rect")
//     .attr("width", x({x: .9}))
//     .attr("x", 0)
//     .attr("y", h)
//     .attr("height", 0)
//   .transition()
//     .delay(function(d, i) { return i * 10; })
//     .attr("y", y1)
//     .attr("height", function(d) { return y0(d) - y1(d); });

// var labels = vis.selectAll("text.label")
//     .data(data[0])
//   .enter().append("svg:text")
//     .attr("class", "label")
//     .attr("x", x)
//     .attr("y", h + 6)
//     .attr("dx", x({x: .45}))
//     .attr("dy", ".71em")
//     .attr("text-anchor", "middle")
//     .text(function(d, i) { return i; });

// vis.append("svg:line")
//     .attr("x1", 0)
//     .attr("x2", w - x({x: .1}))
//     .attr("y1", h)
//     .attr("y2", h);


// function transition() {
//   var stack = d3.select("#chart");

//   stack.select("#group")
//       .attr("class", "first");

//   stack.select("#stack")
//       .attr("class", "last active");

//   stack.selectAll("g.layer rect")
//     .transition()
//       .duration(500)
//       .delay(function(d, i) { return (i % m) * 10; })
//       .attr("y", y1)
//       .attr("height", function(d) { return y0(d) - y1(d); })
//       .each("end", transitionEnd);

//   function transitionEnd() {
//     d3.select(this)
//       .transition()
//         .duration(500)
//         .attr("x", 0)
//         .attr("width", x({x: .9}));
//   }
// }



  // Defined by Backbone.js
  Backbone.Events.bind('chart:redraw', function(message) { transition(message); })
}

Backbone.Events.bind('chart:start', function(message) { start(message); });



  // function transition(msg) {
  //   d3.selectAll("path")
  //       .data(function() {


  //         if (data[0].length > period) {
  //           data[0].shift();
  //           data[1].shift();
  //           console.log('shifting')
  //         }

  //         // console.log(data[0][0].x)

  //         x = 0;

  //         if (data[0][0]) {
  //           x = Date.now() - startTime - data[0][0].x;

  //           console.log('Date.now() - startTime: ' + (Date.now() - startTime))
  //           console.log('data[0][0].x: ' + data[0][0].x)
  //         }

  //         // console.log(x)
  //         a = d3.layout.stack().offset("zero")([ [{x:x, y:msg.iphone}], [{x:x, y:msg.web}] ])

  //         data[0].push(a[0][0]);
  //         data[1].push(a[1][0])

  //         return data;
  //       })
  //     .transition()
  //       .duration(1)
  //       .attr("d", area);
  // }
