const dotenv=require('dotenv');
dotenv.config();
const cors=require('cors');
const express=require('express');
const app=express();
const connectToDb=require("./db/db");
connectToDb();
const cookieParser=require('cookie-parser');
const userRoutes=require("./routes/user.routes");

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({extended:true}));
app.use(cookieParser);

app.get("/",function(req,res){
    res.send("Hello");
})

app.use("/users",userRoutes);

module.exports=app;
