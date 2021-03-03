pragma Singleton
import QtQuick 2.15
import QtQuick.LocalStorage 2.15

QtObject {

    property var db: LocalStorage.openDatabaseSync("DoDiet","1.0","The DoDiet Database",1000000)

    function createTable(){
        let query = 'CREATE TABLE IF NOT EXISTS "Histories" (
    "id"	INTEGER NOT NULL UNIQUE,
    "key"	TEXT,
    "recipeId"	INTEGER,
    "registerDate"	TEXT DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("id" AUTOINCREMENT),
    FOREIGN KEY(recipeId) REFERENCES Recipes(id) ON DELETE CASCADE
);'

        db.transaction(
                    function(tx) {
                        try{
                            tx.executeSql(query);
                        }catch(e){
                            console.exception(e)
                        }
                    }
                    )// end of transaction
    } // end of function

    function insertHistory(dataList){
        let query = 'INSERT INTO Histories(key,recipeId) VALUES(?, ?)'
        let insertId = -1

        db.transaction(
                    function(tx) {
                        try{
                            tx.executeSql(query,dataList);
                            insertId = tx.executeSql("SELECT last_insert_rowid() as id").insertId
                        }catch(e){
                            console.exception(e)
                        }
                    }
                    ) // end of transaction
        return insertId
    }


    function updateHistory(){}
    function deleteHistory(){}
    function getHistories(){}
    function getHistoryByKey(key){
        let returnArray = []
        let query = 'SELECT DISTINCT(key) FROM Histories WHERE key LIKE "%'+key+'%"'
        db.transaction(
                    function(tx) {
                        try{
                            let resualt = tx.executeSql(query);
                            for (var i = 0; i < resualt.rows.length; i++)
                            {
                                returnArray.push(resualt.rows.item(i))
                            }
                        }catch(e){
                            console.exception(e)
                        }
                    }
                    )
        return returnArray
    }
    function getHistoryByColumn(column,value){
        let returnArray = []
        let query = 'SELECT * FROM Histories WHERE '+column+'="'+value+'"'
        db.transaction(
                    function(tx) {
                        try{
                            let resualt = tx.executeSql(query);
                            for (var i = 0; i < resualt.rows.length; i++)
                            {
                                returnArray.push(resualt.rows.item(i))
                            }
                        }catch(e){
                            console.exception(e)
                        }
                    }
                    )
        return returnArray
    }

}
