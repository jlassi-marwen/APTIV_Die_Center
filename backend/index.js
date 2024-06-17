/* Import the functions you need from the SDKs you need
const {firebase} =require ('firebase-admin');
import { initializeApp } from 'firebase/app';
import {getFirestore ,collection} from 'firebase/firestore';
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyDZjzE9Yu5R4deuaA_yD5dr8rbcSfG6U1U",
  authDomain: "aptiv-dcea4.firebaseapp.com",
  projectId: "aptiv-dcea4",
  databaseurl:"https://aptiv-dcea4-default-rtdb.europe-west1.firebasedatabase.app/",
  storageBucket: "aptiv-dcea4.appspot.com",
  messagingSenderId: "233673053191",
  appId: "1:233673053191:web:2c96ca80bdf48fa1f346a2"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
//const db= 'https://aptiv-dcea4-default-rtdb.europe-west1.firebasedatabase.app/'
const db=getFirestore()

const colref=(db,'machines','matieres','usage_time')

function getdata ()
{
  const databaseRef = firebase.database().ref();

  // Fetch data from Firebase Realtime Database
  databaseRef.once('machines', (snapshot) => {
    const data = snapshot.val();
    console.log('Data from Firebase Realtime Database:');
    console.log(data);
  }, (error) => {
    console.error('Error fetching data:', error);
  });
}

const express=require("express")
const app=express
const mongoose=require("mongoose")
const{MONGO_DB_CONFIG}=("./config/app.config")
const errors=require("./middleware/errors")
mongoose.Promise=global.Promise

mongoose.connect(MONGO_DB_CONFIG,{
  useNewUrlParser:true,
  useUnifiedTopology:true
}).then(
  ()=>{
    console.log("connected to database succesfully!");
  },
  (error)=>{
    console.log("could not connect to database"+error)
  }
);

app.use(express.json());
app.use('/uploads',express.static('uploads'));
app.use('/api',require('./routes/app_routes'));
app.use(errors.errorHundler);
app.listen(process.env.PORT||4000,function(){
  console.log("Listening on port"+PORT)
});*/