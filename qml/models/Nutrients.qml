pragma Singleton
import QtQuick 2.15
import QtQuick.LocalStorage 2.15

QtObject {

    property var db: LocalStorage.openDatabaseSync("DoDiet","1.0","The DoDiet Database",1000000)

    function createTable(){
        let query = 'CREATE TABLE IF NOT EXISTS "Nutrients" (
    "id"	INTEGER NOT NULL UNIQUE,
    "NTRCode"	TEXT,
    "name"	TEXT,
    "unit"	TEXT,
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
                    )// end of transaction

        query = 'CREATE TABLE IF NOT EXISTS "NutrientsofRecipe" (
    "id"	INTEGER NOT NULL UNIQUE,
    "nutrientId"	INTEGER,
    "recipeId"	INTEGER,
    "quantity"	REAL,
    "dailyQuantity" REAL,
    FOREIGN KEY(nutrientId) REFERENCES Nutrients(id) ON DELETE CASCADE,
    FOREIGN KEY(recipeId) REFERENCES Recipes(id) ON DELETE CASCADE
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

    function insertNutrient(values){
        let query = 'INSERT INTO Nutrients(NTRCode,name,unit) VALUES '+values
        let insertId = -1

        db.transaction(
                    function(tx) {
                        try{
                            tx.executeSql(query);
                            insertId = tx.executeSql("SELECT last_insert_rowid() as id").insertId
                        }catch(e){
                            console.exception(e)
                        }
                    }
                    ) // end of transaction
        return insertId
    }

    function insertNutrientOfRecipe(dataList){
        let query = 'INSERT INTO NutrientsofRecipe ( nutrientId, recipeId, quantity, dailyQuantity ) VALUES( ?, ?, ?, ?)'
        db.transaction(
                    function(tx) {
                        try{
                            tx.executeSql(query,dataList);
                        }catch(e){
                            console.exception(e)
                        }
                    }
                    ) // end of transaction
    }
    function updateNutrient(){}
    function deleteNutrient(){}
    function getNutrients(){}
    function getNutrientsByRecipe(recipeId){
        let returnArray = []
        let query = 'SELECT DISTINCT(NTRCode) as NTRCode,name,unit,quantity,dailyQuantity FROM Nutrients
JOIN NutrientsofRecipe ON Nutrients.id = nutrientId AND recipeId=?'
        db.transaction(
                    function(tx) {
                        try{
                            let resualt = tx.executeSql(query,recipeId);
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


    function getNutrientByColumn(column,value){
        let returnArray = []
        let query = 'SELECT * FROM Nutrients WHERE '+column+'="'+value+'"'
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
