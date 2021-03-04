pragma Singleton
import QtQuick 2.15
import QtQuick.LocalStorage 2.15

QtObject {

    property var db: LocalStorage.openDatabaseSync("DoDiet","1.0","The DoDiet Database",1000000)

    function createTable(){
        let query = 'CREATE TABLE IF NOT EXISTS "Consumed" (
"id"	INTEGER NOT NULL UNIQUE,
"recipeId"	INTEGER,
"calories" REAL,
"registerDate"	TEXT DEFAULT CURRENT_TIMESTAMP,
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

    function insertConsume(dataList){
        let query = 'INSERT INTO Consumed (recipeId, calories) VALUES (?, ? );'
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
    function updateConsume(){}
    function deleteConsume(){}
    function getConsumed(){
        let returnArray = []
        let query = 'SELECT Recipes.id as recipeId, label, image,Consumed.calories as calories,
strftime("%Y/%m/%d",Consumed.registerDate) as registerDate, strftime("%H:%M",Consumed.registerDate) as registerTime
FROM Consumed JOIN Recipes
ON recipeId= Recipes.id ORDER BY strftime("%Y %m %d",Consumed.registerDate) DESC, Consumed.id DESC'
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
    function getCurrentDayCalories(){
        let query= 'SELECT sum(Consumed.calories) as CurrentDayCalories FROM Consumed JOIN Recipes
ON recipeId= Recipes.id AND strftime("%Y %m %d",Consumed.registerDate)= strftime("%Y %m %d","now")
GROUP BY strftime("%Y %m %d",Consumed.registerDate)'

        let obj = 0
        db.transaction(
                    function(tx) {
                        try{
                            let resualt = tx.executeSql(query);
                            if(resualt.rows.length)
                            {
                                obj= resualt.rows.item(0).CurrentDayCalories
                            }
                        }catch(e){
                            console.exception(e)
                        }
                    }
                    )
        return obj
    }

    function getConsumeByColumnValue(column,value){
        let returnArray = []
        let query = 'SELECT * FROM Consumed WHERE '+column+'="'+value+'"'
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
