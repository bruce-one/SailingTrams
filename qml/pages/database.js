.import QtQuick.LocalStorage 2.0 as Sql
function update(){
    console.log('Updating')
    app.db = app.db || Sql.LocalStorage.openDatabaseSync("SailingTramsDB", "1.0", "SailingTrams", 1000)
    app.db.transaction(function(tx) {
        var rs
        //tx.executeSql('DROP TABLE UserStops;')
        tx.executeSql('CREATE TABLE IF NOT EXISTS UserStops(stopNo NUM, routeNo NUM, PRIMARY KEY(stopNo, routeNo));')
        rs = tx.executeSql('SELECT * FROM UserStops;')
        listModel.clear()
        for(var i = 0, l = rs.rows.length; i < l; i++) {
            listModel.append({name: rs.rows.item(i).stopNo+'', stopNo: rs.rows.item(i).stopNo, routeNo: rs.rows.item(i).routeNo})
        }
    })
}
