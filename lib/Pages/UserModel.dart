class UserModel{

  String userId = "";
  String customername = "";
  String email = "";
  String password =""; 
  String photourl = "";
  String response = "";
  String phone = "";
 // myUser(String userId,String nickName)

 setResponse(String response){
   this.response = response;

 }

setPhone(String phone){
   this.phone = phone;
   
 }

 setUserId(String userId){
   this.userId = userId;
   
 }
 setCustomerName(String customername){
   this.customername = customername;
 }

 setEmail(String email){
   this.email = email;
 }
 setPassword(String password){
   this.password = password;
 }
 setPhotoUrl(String photourl){
   this.photourl = photourl;
 }
 ///////////////////////////////////////////////
 getResponse(){
   return this.response;
 }
 getUserId(){
   return this.userId; 
 }
 getCustomerName(){
   return this.customername;
 }

 getEmail(){
   return this.email;
 }

 getPassword(){
   return this.password;
 }
 
 getPhotoUrl(){
   return this.photourl;
 }
 getPhone(){
   return this.phone;
 }
 
 

}


UserModel userModel = UserModel();