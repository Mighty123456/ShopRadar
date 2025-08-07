const { model } = require("mongoose");
const userModel=require("../models/user.model");

module.exports.createUser=async(name,password,email)=>{
    if(!name || !email || !password){
        throw new Error("All the fields are required");
    }
    const user=await userModel.create({
        name, email, password
    })
    return user;
    //returned to whoever called createUser
}