const userModel=require('../models/user.model');
const bcrypt=require('bcrypt');
const jwt=require('jsonwebtoken');
const blackListTokenModel=require("../models/blacklistToken.model");

module.exports.authUser = async(req,res,next)=>{
    const token= req.cookies.token || req.headers.authorization?.split(' ')[1];
    //.split(' ')[1] means it splits the string by space and picks the token part only.
    //Because req.headers.authorization give full string: Bearer <token>
    
    if(!token){
        return res.status(401).json({message:"Unauthorized"});
    }

    const isBlacklisted = await blackListTokenModel.findOne({token:token});
    if(isBlacklisted){
        return res.status(401).json({message:"Unauthorized"});
    }

    try{
        const decoded= jwt.verify(token,process.env.JWT_SECRET);
        const user= await userModel.findById(decoded._id);
        req.user=user;
        return next();
    }catch(err){
        return res.status(401).json({message:"Unauthorized"});
    }
}