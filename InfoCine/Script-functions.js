

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
        
 
      var imageRow = document.createElement('td');
        imageRow.onclick = function() {
        window.webkit.messageHandlers.openDetails.postMessage('details opened');
        }

        var imageView = document.createElement('img');
        imageView.src = rowData[0];
        imageRow.appendChild(imageView);

        tableBody.appendChild(imageRow);
        
      var textRow = document.createElement('td');
       
        var title = document.createElement('h3');
        title.appendChild(document.createTextNode(rowData[1]));
        textRow.appendChild(title);
      
        var desc = document.createElement('p');
        desc.appendChild(document.createTextNode(rowData[2]));
        textRow.appendChild(desc);
        var devider = document.createElement('hr');
        textRow.appendChild(devider);
        tableBody.appendChild(textRow);

      });


    table.appendChild(tableBody);
      document.body.appendChild(table);
   }
