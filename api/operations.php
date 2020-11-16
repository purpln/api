<?php
require_once 'constants.php';
require_once 'response.php';

function info($token){
    timeUpdate($token);
    return response('values', 'info');
}

function userLogin($username, $password){;
    $mysqli = mysqli_connect(host, username, password, name);
    $stmt = $mysqli->prepare("SELECT token FROM users WHERE username=? AND password=?");
    $stmt->bind_param("ss", $username, $password);
    $stmt->execute();
    $stmt->bind_result($token);
    $stmt->fetch();
    if ($token){
        timeUpdate($token);
        return response($token, 'user login');
    }else{
        return error(error_invalidUserOrPassword);
    }
}

function listUsers($token){
    timeUpdate($token);
    $mysqli = mysqli_connect(host, username, password, name);
    $result = $mysqli->query("SELECT id, username, email, name, rank, color, date, last, photo FROM users");
    $res = [];  
    while ($r = $result->fetch_array(MYSQLI_ASSOC)) {
        $res[] = $r;
    }
    $result->free();
    return response($res, 'list users');
}

function createUser($username, $password, $email){
    if (!isUserExist($username, $email)) {
        $token = randomToken();
        $color = '0';
        $rank = 'user';
        $date = date("Y-m-d H:i:s");
        $photo = '';
        $name = '';
        $mysqli = mysqli_connect(host, username, password, name);
        $stmt = $mysqli->prepare("INSERT INTO users (username, password, email, name, rank, token, color, date, last, photo) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->bind_param("ssssssssss", $username, $password, $email, $name, $rank, $token, $color, $date, $date, $photo);
        if ($stmt->execute()) {
            return response($token, 'user created');
        } else {
            return error(error_userNotCreated);
        }
    } else {
        return error(error_userAlreadyExist);
    }
}

function isUserExist($username, $email){
    $mysqli = mysqli_connect(host, username, password, name);
    $stmt = $mysqli->prepare("SELECT id FROM users WHERE username = ? OR email = ?");
    $stmt->bind_param("ss", $username, $email);
    $stmt->execute();
    $stmt->store_result();
    return $stmt->num_rows > 0;
}

function updateValue($token, $value, $update){
    timeUpdate($token);
    $mysqli = mysqli_connect(host, username, password, name);
    $stmt = $mysqli->prepare("UPDATE users SET $value=? WHERE token=?");
    $stmt->bind_param("ss", $update, $token);
    if ($stmt->execute()) {
        return response($update, "value $value was successfully updated");
    } else {
        return error(error_valueWasNotUpdated);
    }
}

function getUserByUsername($token, $username){
    timeUpdate($token);
    $mysqli = mysqli_connect(host, username, password, name);
    $stmt = $mysqli->prepare("SELECT id, username, email, name, rank, color, date, last, photo FROM users WHERE username = ?");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $stmt->bind_result($id, $uname, $email, $name, $rank, $color, $date, $last, $photo);
    $stmt->fetch();
    $user = array();
    $user['id'] = $id;
    $user['username'] = $username;
    $user['email'] = $email;
    $user['name'] = $name;
    $user['rank'] = $rank;
    $user['color'] = $color;
    $user['date'] = $date;
    $user['last'] = $last;
    $user['photo'] = $photo;
    return response($user, 'get user by username');
}
function getUserByToken($token){
    timeUpdate($token);
    $mysqli = mysqli_connect(host, username, password, name);
    $stmt = $mysqli->prepare("SELECT id, username, password, email, name, rank, token, color, date, last, photo FROM users WHERE token = ?");
    $stmt->bind_param("s", $token);
    $stmt->execute();
    $stmt->bind_result($id, $uname, $pass, $email, $name, $rank, $token, $color, $date, $last, $photo);
    $stmt->fetch();
    $user = array();
    $user['id'] = $id;
    $user['username'] = $uname;
    $user['password'] = $pass;
    $user['email'] = $email;
    $user['name'] = $name;
    $user['rank'] = $rank;
    $user['token'] = $token;
    $user['color'] = $color;
    $user['date'] = $date;
    $user['last'] = $last;
    $user['photo'] = $photo;
    return response($user, 'get user by token');
}
    
function colors($token){
    timeUpdate($token);
    $mysqli = mysqli_connect(host, username, password, name);
    $result = $mysqli->query("SELECT id, name, hex FROM colors");
    $res = [];  
    while ($r = $result->fetch_array(MYSQLI_ASSOC)) {
        $res[] = $r;
    }
    $result->free(); // free result
    return response($res, 'colors');
}
?>