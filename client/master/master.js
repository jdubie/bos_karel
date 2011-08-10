run = function() {

  var socket = io.connect('http://localhost');
  socket.on('connect', function () {
    socket.emit('master',null);
  });
  socket.on('link', function(link) {
    document.getElementById('link').href = link;
    append_qrcode(9,"qr_url",link);
    //document.getElementById('link').innerHTML = link
  });
  socket.on('data', function (data) {

    console.log('data')
    console.log(data.question)

    document.getElementById('question').innerHTML = data.question
    document.getElementById('q1').innerHTML = data.q1
    document.getElementById('q2').innerHTML = data.q2
    document.getElementById('q3').innerHTML = data.q3
    document.getElementById('q4').innerHTML = data.q4
  });
}