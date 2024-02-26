import 'package:msd_project_food_diary/Model/Bmi.dart';
import 'package:msd_project_food_diary/Model/Calories.dart';
import 'package:msd_project_food_diary/Model/Image.dart';
import 'package:msd_project_food_diary/Model/UserGathering.dart';
import 'package:msd_project_food_diary/Model/Username.dart';
import 'package:msd_project_food_diary/Model/UsersModel.dart';
import 'package:msd_project_food_diary/Model/profileimage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Databasehelper {
  Future<Database> InitiDb() async {
    final path = join(await getDatabasesPath(), 'MSD_FoodDairyProrjectdss.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        
        await db.execute(
          '''
CREATE TABLE IF NOT EXISTS Profile(
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  username TEXT UNIQUE,
  weight DOUBLE,
  height INTEGER,
  age INTEGER
)
'''
        );
     

 await db.execute(
  '''
  CREATE TABLE IF NOT EXISTS Usernames (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    username TEXT UNIQUE
  )
  ''',
);
    await db.execute(
          '''
          CREATE TABLE IF NOT EXISTS Users (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            Username TEXT,
            Password TEXT,
            CfmPassword TEXT
          )
          ''',
        );
       await db.execute('''
    CREATE TABLE IF NOT EXISTS images (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      username TEXT,
      path TEXT,
      comments TEXT,
      title TEXT
    )
  ''');
   await db.execute('''
   CREATE TABLE IF NOT EXISTS ProfileImage (
  id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  username TEXT UNIQUE,
  path TEXT
)

  ''');
          await db.execute(
  '''
  CREATE TABLE IF NOT EXISTS BMI (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT,
    bmi DOUBLE
  )
  ''',
);
 await db.execute(
  '''
  CREATE TABLE IF NOT EXISTS Calories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT,
    bmr DOUBLE
  )
  '''
);



      },
    );
  }
  //Insert Records BMR
  Future<void>InsertRecordsBMR(CaloriesData bmr)async{
     final db = await InitiDb();
     await db.insert(
    'Calories',
  bmr.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace
     );
  }


//RetrieveLastBMR Record

 Future<CaloriesData?> retrieveLastBMR(String? username) async {
  final db = await InitiDb();
  final List<Map<String, Object?>> queryResult = await db.query(
    "Calories",
    where: "username=?",
    whereArgs: [username],
    orderBy: "id DESC", // Order by the primary key in descending order
    limit: 1, // Limit the result to one row
  );
  if (queryResult.isNotEmpty) {
    return CaloriesData.fromMap(queryResult.first);
  } else {
    return null; // Return null if no record is found
  }
}

//Retrieve BMR Records

Future<List<CaloriesData>>RetrieveBMRRecords(String? username)async{
    final db = await InitiDb();
  final List<Map<String, Object?>> queryResult = await db.query(
    "Calories",
    where: "username=?",
    whereArgs: [username]
  );
  if(queryResult.isNotEmpty){
      return queryResult.map((e) => CaloriesData.fromMap(e)).toList();

  }else{
    return [];
  }
  }


//RemoveImageID

Future<void> removeByImageId(int?id) async {
  final db = await InitiDb();
  await db.delete("images", where: "id = ?", whereArgs: [id]);
  await db.close(); // Close the database connection after the operation
}

//UpdateImageCommenets

Future<void> updateImageComments(ImageModel imageModel) async {
  final db = await InitiDb();

  final List<Map<String, dynamic>> queryResult = await db.query(
    "images",
    where: 'id = ?',
    whereArgs: [imageModel.id],
  );

  if (queryResult.isNotEmpty) {
    await db.update(
      "images",
      imageModel.toMap(), // Ensure this returns a Map<String, dynamic>
      where: 'id = ?',
      whereArgs: [imageModel.id],
    );
  } else {
    print("Image not found");
  }

  await db.close(); // Close the database connection after the operation
}

//Update Image 

Future<void> updateImage(ImageModel imageModel) async {
  final db = await InitiDb();

  final List<Map<String, dynamic>> queryResult = await db.query(
    "images",
    where: 'id = ?',
    whereArgs: [imageModel.id],
  );

  if (queryResult.isNotEmpty) {
    await db.update(
      "images",
      imageModel.toMap(), // Ensure this returns a Map<String, dynamic>
      where: 'id = ?',
      whereArgs: [imageModel.id],
    );
  } else {
    print("Image not found");
  }

  await db.close(); // Close the database connection after the operation
}

//RetrieveImage

  Future<List<ImageModel>>RetrieveImage(String? username)async{
    final db = await InitiDb();
  final List<Map<String, Object?>> queryResult = await db.query(
    "images",
    where: "username=?",
    whereArgs: [username]
  );
  return queryResult.map((e) => ImageModel.fromMap(e)).toList();
  }
//Retrive Profile Image
  Future<List<ProfileImageModel>>RetrieveProfileImage(String? username)async{
    final db = await InitiDb();
  final List<Map<String, Object?>> queryResult = await db.query(
    "ProfileImage",
    where: "username=?",
    whereArgs: [username]
  );
  if(queryResult.isNotEmpty){
      return queryResult.map((e) => ProfileImageModel.fromMap(e)).toList();

  }else{
    return [];
  }
  }

//Insert Profile Image
   Future<void>InsertProfileImage(ProfileImageModel imageModel)async{
    final db = await InitiDb();
     await db.insert(
    'ProfileImage',
  imageModel.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace
     );
  }

  //Update Profile Image

  Future<void> updateProfileImage(ProfileImageModel imageModel) async {
  final db = await InitiDb();

  final List<Map<String, dynamic>> queryResult = await db.query(
    "ProfileImage",
    where: 'username= ?',
    whereArgs: [imageModel.username],
  );
  if (queryResult.isNotEmpty) {
    await db.update(
      "ProfileImage",
      imageModel.toMap(), // Ensure this returns a Map<String, dynamic>
      where: 'username= ?',
      whereArgs: [imageModel.username],
    );
  
  } else {
    print("Image not found");
  }

  await db.close(); // Close the database connection after the operation
}


  //Insert Image

  Future<void>InsertImage(ImageModel imageModel)async{
    final db = await InitiDb();
     await db.insert(
    'images',
  imageModel.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace
     );
  }

  //Insert BMI


  Future<void>InsertBMI(BMI bmi)async{
    final db = await InitiDb();
     await db.insert(
    'BMI',
    bmi.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace
     );
  }

  //Retrive BMI List
  Future<List<BMI>>RetrieveBMI(String username)async{
   
  final db = await InitiDb();
  final List<Map<String, Object?>> queryResult = await db.query(
    "BMI",
    where: "username=?",
    whereArgs: [username],
  );

  
  if (queryResult.isNotEmpty) {
    return queryResult.map((e) =>BMI.fromMap(e)).toList();
  }

  return [];
  }

  //Retrieve Last Records BMI

  Future<BMI?> RetrieveLastBMI(String username) async {
  final db = await InitiDb();
  final List<Map<String, Object?>> queryResult = await db.query(
    "BMI",
    where: "username = ?",
    whereArgs: [username],
    orderBy: "id DESC", // Assuming id is the primary key column
    limit: 1, // Limit the result to one row
  );

  if (queryResult.isNotEmpty) {
    return BMI.fromMap(queryResult.first);
  }

  return null;
}



//Update BMI

  

  Future<void>UpdateBMI(BMI bmi)async{
  final db = await InitiDb();
    final List<Map<String, Object?>> queryResult = await db.query(
    "BMI",
    where: 'username = ?',
    whereArgs: [bmi.username],
  );
   if (queryResult.isNotEmpty) {
     await db.update("Profile", bmi.toMap(), where: "id=?", whereArgs: [bmi.id]);
  }

}






//Insert New Profile

  Future<void>InsertNewProfie(UserProfile profile)async{
    final db = await InitiDb();
     await db.insert(
    'Profile',
    profile.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace
     );
  }

//RetriveProfile 


 Future<List<UserProfile>> RetriveProfile(String username) async {

  final db = await InitiDb();
  final List<Map<String, Object?>> queryResult = await db.query(
    "Profile",
    where: "username=?",
    whereArgs: [username],
  );

  
  if (queryResult.isNotEmpty) {
    return queryResult.map((e) => UserProfile.fromMap(e)).toList();
  }

  return [];
}

//Update User Profiling 
Future<void>UpdateUserProfile(UserProfile profile)async{
  final db = await InitiDb();
    final List<Map<String, Object?>> queryResult = await db.query(
    "Profile",
    where: 'username = ?',
    whereArgs: [profile.username],
  );
   if (queryResult.isNotEmpty) {
     await db.update("Profile", profile.toMap(), where: "id=?", whereArgs: [profile.id]);
  }

}


/*

Future<List<Recipe>> RetrieveRecipe(String username) async {
  final db = await InitiDb();
  final List<Map<String, Object?>> queryResult = await db.query(
    "Recipe",
    where: 'username = ?',
    whereArgs: [username],
  );
  return queryResult.map((e) => Recipe.fromMap(e)).toList();
}

Future<void> deleteCollectionRecipeName(String name) async {
  final db = await InitiDb();
  final List<Map<String, Object?>> queryResult = await db.query(
    "RecipeCollections",
    where: 'name = ?',
    whereArgs: [name],
  );
  if (queryResult.isNotEmpty) {
    // Perform delete operation if the recipe name exists
    await db.delete("RecipeCollections", where: "name = ?", whereArgs: [name]);
  } else {
    // No action needed if the recipe name doesn't exist
    print("Recipe with name $name not found.");
  }
}
*/

//Insert Username

Future<void> insertUsername(Username username) async {
  final Database db = await InitiDb();
  await db.insert(
    'Usernames',
    username.ToMap(),
    conflictAlgorithm: ConflictAlgorithm.ignore, // Use ignore to prevent duplicates
  );
}

//GetUsername



Future<String> getUsername(String username) async {
  final Database db = await InitiDb();

  final List<Map<String, dynamic>> maps = await db.query(
    'Usernames',
    where: 'username = ?',
    whereArgs: [username],
  );

  // If maps is not empty, return the username string
  if (maps.isNotEmpty) {
    return maps[0]['username'] as String;
  } else {
    // If no usernames found, return null
    return "";
  }
}

 /*
Future<void> insertRecipeCollections(RecipeCollection recipe) async {
  final db = await InitiDb();
   final List<Map<String, Object?>> queryResult = await db.query(
    "RecipeCollections",
    where: 'name = ?',
    whereArgs: [recipe.name],
  );
  if(queryResult.length>0){
    print("duplicate found");
  }else{
    
    await db.insert(
      'RecipeCollections',
      recipe.toMap(),
    );
  }
}
   Future<List<RecipeCollection>> retrieveRecipe(String username) async {
  // Retrieve data from the database
  final db = await InitiDb();
  List<Map<String, dynamic>> recipes = await db.query(
    'RecipeCollections',
    where: 'username = ?',
    whereArgs: [username],
  );

  // Convert the retrieved data into a list of RecipeCollection objects
  List<RecipeCollection> recipeCollections = [];
  for (Map<String, dynamic> recipe in recipes) {
    // Split the combined string of ingredients and instructions
   

    // Create a RecipeCollection object with the separate fields
    RecipeCollection recipeCollection = RecipeCollection(
      id: recipe['id'], // Assign the id from the database
      username: recipe['username'],
      name: recipe['name'],
      ingredients: recipe['ingredients'],
      instructions: recipe['instructions'],
      imageUrl: recipe['imageUrl'],
      nutritionInfo: NutritionInfos(
        calories: recipe['calories'].toDouble(),
        carbohydrates: recipe['carbohydrates'].toDouble(),
        sugar: recipe['sugar'].toDouble(),
        sodium: recipe['sodium'].toDouble(),
        proteins: recipe['proteins'].toDouble(),
        fats: recipe['fats'].toDouble(),
        fiber: recipe['fiber'].toDouble(),
        type: recipe['type'],
        cooktime: recipe['cooktime'],
        serving: recipe['serving'],
        saturatedFats: recipe['saturatedFats'].toDouble(),
        glucose: recipe['glucose'].toDouble(),
      ),
    );

    // Add the created RecipeCollection object to the list
    recipeCollections.add(recipeCollection);
  }

  return recipeCollections;
}

  

  

  Future<Map<String, dynamic>> insertRecipe(Recipe recipe) async {
    final db = await InitiDb();

    // Check if a recipe with the same name already exists
    List<Map<String, dynamic>> existingRecipe = await db.query(
      "Recipe",
      where: "name = ?",
      whereArgs: [recipe.name],
    );

    // If the recipe with the same name already exists, return it
    if (existingRecipe != null && existingRecipe.isNotEmpty) {
      return existingRecipe.first;
    }

    // If the recipe with the same name does not exist, insert the new recipe
    int insertedId = await db.insert(
      'Recipe',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Retrieve the inserted recipe and return it
    Map<String, dynamic>? insertedRecipe = await retrieveRecipeById(insertedId);
    return insertedRecipe ?? {};
  }

  Future<Map<String, dynamic>?> retrieveRecipeById(int id) async {
    final db = await InitiDb();
    List<Map<String, dynamic>> queryResult = await db.query(
      'Recipe',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1, // Limit the query to return only one result
    );
    if (queryResult.isNotEmpty) {
      return queryResult.first; // Return the first (and only) map in the list
    } else {
      return null; // Return null if no results were found
    }
  }

*/

//Insert Records 

  Future<int> InsertRecords(Users register) async {
  final db = await InitiDb();

  // Check if the username already exists in the database
  List<Map<String, dynamic>> existingRecords = await db.query(
    "Users",
    where: "Username = ?",
    whereArgs: [register.username],
  );

  if (existingRecords.isNotEmpty) {
    // If the username already exists, return 0 to indicate failure
    return 0;
  }

  // If the username doesn't exist, proceed with the insertion
  int result = await db.insert(
    "Users",
    register.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  return result;
}

//RetrievData for Users

  Future<List<Users>> RetriveData() async {
    final db = await InitiDb();
    final List<Map<String, Object?>> queryResult = await db.query("Users");
    return queryResult.map((e) => Users.fromMap(e)).toList();
  }


//PreventUser Registering

 Future<int> PreventRegisterAccount(Users registering) async {
  final db = await InitiDb();
  List<Map<String, dynamic>> result = await db.rawQuery(
    "SELECT * FROM Users WHERE Username = ?",
    [registering.username],
  );
  return result.length; // Returns the number of records found with the provided username
}

//Check User if Exsited 

Future<int>CheckifUserExisted(Users logging)async{
  final db  = await InitiDb();
   List<Map<String, dynamic>> resultuser = await db.rawQuery(
    "SELECT * FROM Users WHERE Username = ?",
    [logging.username],
  );
 

   return resultuser.length;
 
}

//Update Password


Future<void>UpdatePassword(Users resetting)async{
  final db  = await InitiDb();
      Map<String, dynamic> data = resetting.toMap();
  db.update("Users", data, where: "Username=?",whereArgs: [resetting.username]);

}

//Check Password is Exsited



Future<int>CheckifPasswordExisted(Users logging)async{
  final db  = await InitiDb();
   List<Map<String, dynamic>> resultuserpassword = await db.rawQuery(
    "SELECT * FROM Users WHERE Password = ?",
    [logging.password],
  );
 

   return resultuserpassword.length;
 
}


//Delete Records

  Future<int> DeleteRecords(int id) async {
    final db = await InitiDb();
    int result = await db.delete("Register", where: "id=?", whereArgs: [id]);
    return result;
  }

//Update Data Register 

  Future<void> UpdateData(Users register) async {
    final db = await InitiDb();
    Map<String, dynamic> data = register.toMap();
    await db.update("Register", data, where: "id=?", whereArgs: [register.id]);
  }

//Delete Records in Register By ID
  Future<void> DeleteDataById(int id) async {
    final db = await InitiDb();
    await db.delete("Register", where: "id=?", whereArgs: [id]);
  }
}
