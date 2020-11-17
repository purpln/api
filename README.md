# Simple php-json rest api with iOS UIKit Example

<img src=https://raw.githubusercontent.com/purpln/purpln/main/images/api4.png>

<img src=https://raw.githubusercontent.com/purpln/purpln/main/images/api3.png>

<img src=https://raw.githubusercontent.com/purpln/purpln/main/images/api5.png>

<img src=https://raw.githubusercontent.com/purpln/purpln/main/images/api6.png>

App features:
- UI programmatically 
- UICollection and UITable programmatically 
- UICollection and UITable cells
- iOS 10 to iOS 14 support (iPhone 5 to iPhone 12)
- Custom php REST Api
- Search bar
- Custom navbar
- iPad master and detail view support 
- Classes of elements
- Server UTC time to local
- Server hex color to rgba UICololr

## Instructions:

### Server side setup
You need php and mySQL server. To set up mySQL users table for api just use this command:

```mysql
CREATE TABLE users (
	id int  NOT NULL PRIMARY KEY AUTO_INCREMENT,
	username varchar(32)  NOT NULL,
	password text  NOT NULL,
	email varchar(64) NOT NULL,
	name varchar(64) NOT NULL,
	rank varchar(16) NOT NULL,
	token varchar(16) NOT NULL,
	color int  NOT NULL,
	date datetime NOT NULL,
	last datetime NOT NULL,
	photo varchar(128) NOT NULL
);
```

Next copy files from folder api to folder on your server, for example I use folder named "api" on my server: [purpln.ml/api](http://purpln.ml/api). To set up api edit **api/constants.php** file:
```php
  define('username', '_username_value_'); //put username of your mysql database instead of "_username_value_"
  define('password', '_password_value_'); //put password of your mysql database instead of "_password_value_"
  define('host', 'localhost'); //default value, change if you know what you change
  define('name', '_database_name_value_'); //put your table name from your mysql database instead of "_table_name_value_"
  
  define('key', '_key_value_'); //put your custom key instead of "_key_value_" so that no body could gain access to your api
  ...
```

Also you can find errors and their descriptions in **api/constants.php** file:
```php
  define('error_server', 'server error');
  define('error_noData', 'no data');
  define('error_noKey', 'no key');
  define('error_noOperation', 'no operation');
  define('error_noValues', 'no values');
  define('error_invalidKey', 'invalid key');
  ...
```

### Request and response format
Your POST request must look like:
```json
{
  "key":"test",
  "operation":"updateValue",
  "values":{
    "token":"_user_token_",
    "value":"name",
    "update":"Sergey Romanenko"
  }
}
```
"key" must always have value you defined in **api/constants.php** file on your server.
"operation" must have some of default values: echo, info, userLogin, createUser, updateValue, getUserByUsername, getUserByToken, listUsers, colors. To make new operation you need to put new function in **api/operations.php** file. For example lets make new update value function for value in your database's table:

```php
function updateValue($token, $value, $update){ //define values you need in this function
    timeUpdate($token); //update user last online time, for example to use it like: "user ADMIN was online on 1'st of January at 10 pm" this value stored in your table as "last"
    $mysqli = mysqli_connect(host, username, password, name); //mySQL connection with host, username, password, name values you defined in api/constants.php file
    $stmt = $mysqli->prepare("UPDATE users SET $value=? WHERE token=?"); //mySQL action
    $stmt->bind_param("ss", $update, $token);
    if ($stmt->execute()) {
        return response($value, 'value was successfully updated'); //success response, first value would be send in respons->values (you can response as string, array, or even array of array, like "listUsers" operation do, second value would be send in respons->info->data
    } else {
        return error(error_valueWasNotUpdated); //error response, error defined in api/constants.php file
    }
}
```
And in **api/index.php** add our new function:
```php
$values = $json['values'];
    switch($json['operation']){
        case 'info': return info($json['values']);
        case 'echo': return response($json['values'], 'echo');
        case 'updateValue': return updateValue($values['token'], $values['value'], $values['update']); //new function with values
        case 'listUsers': return listUsers($json['values']);
...
```

Server success response:
```json
{
    "values": "Sergey Romanenko",
    "info": {
        "api": "api",
        "version": "1.0.0",
        "description": "by Sergey Romanenko",
        "error": false,
        "data": "value name was successfully updated",
        "seed": "db390de80f44"
    }
}
```

Server error response:
```json
{
    "info": {
        "api": "api",
        "version": "1.0.0",
        "description": "by Sergey Romanenko",
        "error": true,
        "data": "value wasn't updated",
        "seed": "39ef06ca1a19"
    }
}
```

And server side is done! You can check it with [rest api post checker](https://reqbin.com/req/v0crmky0/rest-api-post-example), example

<img src=https://raw.githubusercontent.com/purpln/purpln/main/images/api2.png>

### iOS app setup

In my app example you can find **app/api/api.swift** file, where you need to setup your api

```swift
let key:String = "_key_value_" //key you defined on your server
let url:String = "https://example.com/test/" //link to api folder on your server
```

Simple function, that POST on server value "Sergey Romanenko" to update name of the user with the token that stored in defaults.token struct:
```swift
let api = restapi() //name of the class

api.values(.updateValue, ["token":defaults.token, "value":"name", "update":"Sergey Romanenko"]){result in
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(apiDate)
    if let json = try? decoder.decode(actionString.self, from: result) {
        DispatchQueue.main.async{
            information = json.info
            self.showError(information.data, information.error)
        }
    }else if let json = try? decoder.decode(actionError.self, from: result) {
        DispatchQueue.main.async{
            information = json.info
            self.showError(information.data, information.error)
        }
    }else{
        print(String(data: result, encoding: String.Encoding.utf8)!)
    }
}
```
This function returns server response. It tries to decode response, if some error occurred it tries to decode it second time, but if something is actually wrong function print the body of server's response to the console.

To send one value use this function:
```swift
api.value(.updateValue, "_value_")
```
In function you can see ".updateValue" - this is a definition of operation server need to do. This operations also defined in **app/api/api.swift** file, you can append the enum "operations", if you created some new action on server side.
Structs that decode server's response are in **app/api/structs.swift** file. There are two basic structs ("actionString" and "actionError") that decodes most of responses.

### That's it. Basic work of my api and app
