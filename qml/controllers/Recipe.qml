import QtQuick 2.15
import models 1.0
QtObject {

    property string app_id: "92ffd8af"
    property string app_key: "f95d8d0e8ed9e36ec4045325c48af050"

    function getItemsByQuery(data,model,from=0,to = 10)
    {
        var xhr= new XMLHttpRequest()
        let url = "https://api.edamam.com/search?"

        changeStatus("searching");

        data.app_id = app_id
        data.app_key = app_key
        data.from = from
        data.to = to

        let dataString = Object.keys(data).map((key) => {
                                                   return encodeURIComponent(key) + '=' + encodeURIComponent(data[key])
                                               }).join('&')
        url+=dataString

        xhr.withCredentials = true;
        xhr.responseType = 'json';
        xhr.open("GET", url,true);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.timeout = 10000;
        xhr.send();

        xhr.onreadystatechange = function ()
        {
            if (xhr.readyState === XMLHttpRequest.DONE)
            {
                try
                {
                    let response = xhr.response
                    if(!response.hits.length)
                    {
                        changeStatus("not-found")
                        return
                    }

                    for(let i=0; i<response.hits.length;i++)
                    {
                        let item = response.hits[i].recipe
                        let recipeId = -1
                        var itemInDb = RecipeModel.getRecipeByColumnValue("uri",item.uri)
                        if( !itemInDb.length )
                        {
                            /**************** Save recipe in db ********************/
                            recipeId = RecipeModel.insertRecipe([
                                                                    item.uri,
                                                                    item.label,
                                                                    item.image,
                                                                    item.source,
                                                                    item.url,
                                                                    item.yield,
                                                                    item.calories,
                                                                    item.totalWeight,
                                                                    item.dietLabels[0]??"",
                                                                    item.healthLabels[0]??"",
                                                                    item.shareAs,
                                                                    "<ul><li>"+item.ingredientLines.join("</li><li>")+"</li></ul>"
                                                                ])
                            HistoriesModel.insertHistory([response.q,recipeId])

                            /**************** Save nutrients in db ********************/
                            Object.keys(item.totalNutrients).map(
                                        (key) => {
                                            let nutId =-1
                                            try{
                                                nutId = (NutrientsModel.getNutrientByColumn("NTRCode",key))[0].id
                                            }
                                            catch(e){
                                                nutId = NutrientsModel.insertNutrient('("'+key+'","'+item.totalNutrients[key].label+'","'+item.totalNutrients[key].unit+'")')
                                            }
                                            NutrientsModel.insertNutrientOfRecipe([nutId,recipeId,(item.totalNutrients[key]?item.totalNutrients[key].quantity:0).toFixed(2)
                                                                                   ,(item.totalDaily[key]?item.totalDaily[key].quantity:0).toFixed(2)])
                                        })
                            /**************** append to model ********************/

                            model.append({
                                             localId:parseInt(recipeId),
                                             label:item.label,
                                             image:item.image,
                                             calories:item.calories,
                                             dietLabels:item.dietLabels[0]??"",
                                             healthLabels:item.healthLabels[0]??"",
                                             share:item.shareAs
                                         })
                        }//end of if
                        else{
                            recipeId = itemInDb[0].id
                            model.append({
                                             localId:parseInt(recipeId),
                                             label:itemInDb[0].label,
                                             image:itemInDb[0].image,
                                             calories:itemInDb[0].calories,
                                             dietLabels:itemInDb[0].dietLabels??"",
                                             healthLabels:itemInDb[0].healthLabels??"",
                                             share:itemInDb[0].share
                                         })
                        }

                        delete recipeId
                        delete item
                        delete itemInDb
                    }
                    changeStatus("")
                }
                catch(e){
                    console.exception(e)

                }
            }
        };
    }
}


