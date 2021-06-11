if(window.infocine == undefined){
    window.infocine={};
};

function createTable() {
    
    var table = document.createElement('table');
    window.tableBody = document.createElement('tbody');
    
    table.appendChild(window.tableBody);
    document.body.appendChild(table);
    
}

function fillTable(data) {
    
    var cell = document.createElement('tr');
    cell.onclick = function() {
        window.webkit.messageHandlers.openDetails.postMessage(data[0][0]);
    }
    window.tableBody.appendChild(cell);
    
    data.forEach(function(rowData) {
        
        var imageRow = document.createElement('td');
        
        var imageView = document.createElement('img');
        imageView.src = rowData[1];
        imageRow.appendChild(imageView);
        
        cell.appendChild(imageRow);
        
        var textRow = document.createElement('td');
        
        var title = document.createElement('h3');
        title.appendChild(document.createTextNode(rowData[2]));
        textRow.appendChild(title);
        
        var desc = document.createElement('p');
        desc.appendChild(document.createTextNode(rowData[3]));
        textRow.appendChild(desc);
        var devider = document.createElement('hr');
        textRow.appendChild(devider);
        cell.appendChild(textRow)
        
    });
    
}

function clearTable() {
    var list = document.querySelector('table');
    list.remove();
}
