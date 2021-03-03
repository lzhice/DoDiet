pragma Singleton
import QtQuick 2.15
import QtQuick.LocalStorage 2.15

QtObject {

    property var db: LocalStorage.openDatabaseSync("DoDiet","1.0","The DoDiet Database",1000000)

    function createTable(){
        let query = 'CREATE TABLE IF NOT EXISTS "Recipes" (
"id"	INTEGER NOT NULL UNIQUE,
"uri"	TEXT UNIQUE,
"label"	TEXT,
"image"	TEXT,
"source"    TEXT,
"url"	TEXT,
"yield"	INTEGER,
"calories"	REAL,
"totalWeight"	REAL,
"registerDate"	TEXT DEFAULT CURRENT_TIMESTAMP,
"dietLabels"    TEXT,
"healthLabels"  TEXT,
"share"  TEXT,
"ingredientLines"   TEXT,
PRIMARY KEY("id" AUTOINCREMENT)
);'
        db.transaction(
                    function(tx) {
                        try{
                            tx.executeSql(query);
                        }catch(e){
                            console.exception(e)
                        }
                    }
                    ) // end of transaction
    } // end of function

    function insertRecipe(dataList){
        let query = 'INSERT INTO Recipes (uri, label, image, source, url, yield, calories, totalWeight, dietLabels, healthLabels, share,ingredientLines )
                                  VALUES (?,    ?,      ?,      ?,    ?,    ?,      ?,        ?,            ?,          ?,          ?,      ? );'
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
    function updateRecipe(){}
    function deleteRecipe(){}
    function getRecipes(){}

    function getRecipeById(id){
        let query = 'SELECT * FROM Recipes WHERE id=?'
        let obj = {}
        db.transaction(
                    function(tx) {
                        try{
                            let resualt = tx.executeSql(query,id);
                            if(resualt.rows.length)
                            {
                                obj= resualt.rows.item(0)
                            }
                        }catch(e){
                            console.exception(e)
                        }
                    }
                    )
        return obj
    }

    function getRecipeByColumnValue(column,value){
        let returnArray = []
        let query = 'SELECT * FROM Recipes WHERE '+column+'="'+value+'"'
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
