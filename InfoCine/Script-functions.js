

if(window.infocine == undefined){
    window.infocine={};
};

window.infocine.acceptCookies = function(fullname) {
    document.querySelector('#fullname').innerText += fullname;
};


function createTable(tableData) {
  var table = document.createElement('table');
  var tableBody = document.createElement('tbody');

  tableData.forEach(function(rowData) {
    var row = document.createElement('tr');

    rowData.forEach(function(cellData) {
      var cell = document.createElement('td');
      cell.appendChild(document.createTextNode(cellData));
      row.appendChild(cell);
    });

    tableBody.appendChild(row);
  });

  table.appendChild(tableBody);
    document.body.appendChild(table);
   }
