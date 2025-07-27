const mongoose=require('mongoose');
const bcrypt=require('bcrypt');
const jwt=require('jsonwebtoken');

const userSchema=mongoose.Schema({
    name:{
        type:String,
        required:true,
        minlength:[3,"Name must be 3 characters long"]
    },
    email:{
        type:String,
        required:true,
        unique:true,
        minlength:[5,"Email must be 5 characters long"]
    },
    password:{
        type:String,
        required:true,
        select:false
        //It tells mongoose to prevent accidentally exposing password when fetching users.
    },
    socketId:{
        type:String
    }
})

userSchema.methods.generateAuthToken = function(){
    const token=jwt.sign({_id:this._id},process.env.JWT_SECRET,{expriesIn:'24h'});
    return token;
}

userSchema.statics.hashPassword = async function(password){
    return await bcrypt.hash(password,10);
}

userSchema.methods.comparePassword = async function(password){
    return await bcrypt.compare(password,this.password);
}

module.exports = mongoose.model('user',userSchema);

//There are two methods static and instance method
//Static method is used on model and applies generally.(eg,hashPassword)
//Instance method is used on document and applies to specific user.(eg,comparePassword,generateAuthToken)