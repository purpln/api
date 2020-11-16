<?php
require_once 'constants.php';
require_once 'operations.php';
require_once 'response.php';

function func(){
    $json = json_decode(file_get_contents('php://input'), true);
    if (empty(file_get_contents('php://input'))) {
        return error(error_noData);
    }else if ( empty($json['key']) ){
        return error(error_noKey);
    }else if ( empty($json['operation']) ){
        return error(error_noOperation);
    }else if ( empty($json['values']) ){
        return error(error_noValues);
    }else if ( $json['key'] != key){
        return error(error_invalidKey);
    }else{
        return operation($json);
    }
}

function operation($json){
    $values = $json['values'];
    switch($json['operation']){
        case 'info': return info($json['values']);
        case 'echo': return response($json['values'], 'echo');
        case 'updateValue': return updateValue($values['token'], $values['value'], $values['update']);
        case 'listUsers': return listUsers($json['values']);
        case 'userLogin': return userLogin($values['username'], $values['password']);
        case 'createUser': return createUser($values['username'], $values['password'], $values['email']);
        case 'getUserByUsername': return getUserByUsername($values['token'], $values['username']);
        case 'getUserByToken': return getUserByToken($json['values']);
        case 'colors': return response(colors());
        default: return error(error_invalidOperation);
    }
}
echo json_encode(func(), JSON_PRETTY_PRINT);
?>