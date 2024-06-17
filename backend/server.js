/*const firebase = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json'); // Replace with the path to your service account key JSON file
firebase.initializeApp({
  credential: firebase.credential.cert(serviceAccount),
  databaseURL: 'https://your-project-id.firebaseio.com' // Replace with your Firebase project URL
});

*/



require ('dotenv').config()
const express=require('express')
const mongoose=require('mongoose')
const app=express()
const cors = require('cors'); // Import the cors package

const toolsroute=require('./routes/tools')
const machineroute=require('./routes/machines')
const assignmentroute=require('./routes/assignment')
const repairroute=require('./routes/repair')
const userRoutes = require('./routes/user')
const statsroute=require('./routes/stats')
const corsOptions = {
    origin:'*', // Allow requests only from this origin
    methods:['GET', 'POST','PUT','DELETE'],      // Allow only specified methods
    allowedHeaders: ['Authorization', 'Content-Type','Access-Control-Allow-Origin' ], // Allow only specified headers
  };
  
  app.use(cors(corsOptions));  
//middleware
app.use(express.json())
app.use('/',(req,res,next)=>{
    console.log(req.path,req.method)
    next()
})

//nodejs route (path)

app.use('/api/tools',toolsroute)
app.use('/api/machines',machineroute)
app.use('/api/assignment',assignmentroute)
app.use('/api/repair',repairroute)
app.use('/api/users', userRoutes)
app.use('/api/stats',statsroute);  


//connect to database with mongoose

mongoose.connect(process.env.MONGO_URI)
    .then(()=>{
        //listen to requests
app.listen(process.env.PORT , ()=>{
    console.log('listenng on port ',process.env.PORT,'OK!')
})
    })
    .catch((error)=>{
        console.log(error)
    })

module.exports=app;