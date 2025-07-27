const userModel=require("../models/user.model");
const userService=require("../services/user.service");
const {validationResult}= require("express-validator");
const blackListTokenModel = require("../models/blacklistToken.model");

module.exports.signupUser = async(req,res,next)=>{
    const errors=validationResult(req);
    if(!errors.isEmpty()){
        return res.send(400).json({errors:errors.array()});
    }
    const {name, email, password}=req.body;

    const isAlreadyUser = await userModel.findOne({email});
    if(isAlreadyUser){
        return res.status(401).json({message:"User Already Exists"});
    }

    const hashedPassword=await userModel.hashPassword(password);

    const user= await userService.createUser({
        name, email, password:hashedPassword
    });

    const token=user.generateAuthToken();
    res.status(201).json({token,user});
}

module.exports.loginUser= async(req,res,next)=>{
    const errors=validationResult(req);
    if(!errors.isEmpty()){
        return res.status(400).json({errors:errors.array()});
    }
    const {email,password}=req.body;

    const user=await user.Model.findOne({email:email}).select("+password");
    if(!user){
        return res.status(404).json({message:"Invalid email or password"});
    }

    const isMatch=await user.comparePassword(password);
    if(!isMatch){
        return res.status(400).json({message:"Invalid email or password"});
    }

    const token =user.generateAuthToken();
    res.cookie("token",token);
    res.status(200).json({token,user});
}

module.exports.getUserProfile = async(req,res,next)=>{
    res.status(400).json(req.user);
}

module.exports.logoutUser = async(req,res,next)=>{
    res.clearcookie("token");
    const token=req.cookies.token || req.headers.authorization.split(' ')[1];

    await blackListTokenModel.create({token});

    res.status(200).json({message:"Logged Out "});
}

//controller consists of logic of routes