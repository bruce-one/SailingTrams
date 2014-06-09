.import QtQuick.LocalStorage 2.0 as Sql
function update(){
    console.log('Updating')
    app.db = app.db || Sql.LocalStorage.openDatabaseSync("SailingTramsDB", "", "SailingTrams", 1000)

    try {
        app.db.changeVersion('', '1.0', function(tx){
            console.log('Database init')
            tx.executeSql('CREATE TABLE IF NOT EXISTS UserStops(stopNo NUM, routeNo NUM, PRIMARY KEY(stopNo, routeNo));')
        })
        app.db = Sql.LocalStorage.openDatabaseSync("SailingTramsDB", "1.0", "SailingTrams", 1000)
    } catch(e){}
    try {
        app.db.changeVersion('1.0', '2.0', function(tx){
            console.log('Database 1 to 2')
            tx.executeSql('ALTER TABLE UserStops ADD nickname TEXT;')
        })
    } catch(e){}
    app.db = Sql.LocalStorage.openDatabaseSync("SailingTramsDB", "2.0", "SailingTrams", 1000)
    app.db.transaction(function(tx) {
        var rs
        rs = tx.executeSql('SELECT * FROM UserStops;')
        listModel.clear()
        for(var i = 0, l = rs.rows.length; i < l; i++) {
            listModel.append({name: (rs.rows.item(i).nickname ? rs.rows.item(i).nickname : qsTr("Stop ") + rs.rows.item(i).stopNo+''), stopNo: rs.rows.item(i).stopNo, routeNo: rs.rows.item(i).routeNo})
        }
    })
}
