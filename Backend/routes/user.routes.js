const express=require('express');
const router=express.Router();
//Router allows us to organize into separate files instead of putting all router in one file(app.js or server.js)
//app.js will only have user as a router whereas user.routes.js will consists of user routes like login, signup(user->login,signup)
const {body}=require("express-validator");
//body method is import to create validation rules for the request body
const userController=require("../controllers/user.controller");
const authMiddleware=require("../middlewares/auth.middleware");

router.post("/signup",[
    body("name").isLength({min:3}).withMessage("First name must be 3 characters long"),
    //checks if req.body.name is 3 characters long
    body("email").isEmail().withMessage("Invalid Email"),
    body("password").isLength({min:6}).withMessage("Password length must be 6 characters long")
],
    userController.signupUser
    //checks for validation errors and perform the action
    //Routes just check the data whereas controller sees if there is any error in data and performs the action
)

router.post("/login",[
    body("email").isEmail().withMessage("Invalid Email"),
    body("password").isLength({min:6}).withMessage("Password length must be 6 characters long")
],
    userController.loginUser
    //loginUser is a function in user.controller.js that handles the login logic
)  

router.get("/profile", authMiddleware.authUser, userController.getUserProfile)

router.get("/logout",authMiddleware.authUser,userController.logoutUser);

module.exports=router;