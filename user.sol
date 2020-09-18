pragma solidity 0.6.6;
pragma experimental ABIEncoderV2;

//import "./helpers.sol";
import "./safemath.sol";

/*
library modifiers {
    modifier validateUser(address currUser) {
        require(users[currUser].permissions == 1, "Invalid Credentials.");
        _;
    }
}

interface staging {
    modifier validate(address curr) {
        require(modifiers.validateUser(curr));
        _;
    }
}*/

library stor {
    struct User {
        bytes32 username;
        uint8 permissions;
        uint joined;
        bool valid;
    }
    
    struct newsArticles{
        string text;
        bytes32 authName;
        bytes32 title;
        bytes32 publishedBy;
        uint published;
        uint _id;
        bool valid;
    }
    
   struct userArticles {
        address authAddress;
        bytes32 authName;
        bytes32 title;
        bytes32[] references;
        string text;
        uint date;
        uint id;
        uint newsArticleId;
        bool valid;
    }
    
    modifier validateUser(address currUser) {
        //require(users[currUser].permissions == 1, "Invalid Credentials.");
        _;
    }
}

contract news{
    
    using SafeMath for uint256;
    
    uint private _id = 0;
    
    stor.newsArticles[] public newsCatalog;
    
    mapping(uint => stor.newsArticles) test;
    
    /*
    temp until alternate way of gethering news articles is made
    @function generates news articles for proof of work
    */
    function createNewsArticle(string memory text, bytes32 title) public returns(bool success){
        
        newsCatalog.push(stor.newsArticles({
            text: text,
            authName: "josh",
            title: title,
            publishedBy: "New York TImes",
            published: now,
            _id: _id = _id.add(1),
            valid: true
        }));
        
        return true;
    }
    
    function getArticleById(uint id) public view returns(stor.newsArticles memory){
        require(newsCatalog[id].valid, "Item does not exist.");
        
        return newsCatalog[id];
    }
    
    function getNewsByTitle(bytes32 title) public view returns(stor.newsArticles memory){  return newsCatalog[_searchNewsItems(title)]; }
    function getNewsByAuthor(bytes32 author) public view returns(stor.newsArticles memory){   return newsCatalog[_searchNewsItems(author)];    }
    
    function _searchNewsItems(bytes32 item) internal view returns(uint) {
        for(uint i = 0; i < newsCatalog.length; i++) {
            if(newsCatalog[i].title == item || newsCatalog[i].authName == item) {
                return i;
            }
        }
    }
    function returnNewsCatalog() public view returns(stor.newsArticles[] memory){
        require(newsCatalog.length > 0, "News Catalog is empty.");
        
        return newsCatalog;
    }
}

contract user is news {
    
    using SafeMath for uint256;
    
    mapping(address => stor.User) public users;
    
    event createdUser(stor.User newUser);
    
    
    //Stores new users data
    function createUser(bytes32 name) public returns(bool success){
        require(!users[msg.sender].valid, "User Already Exists");

        users[msg.sender].username  = name;
        users[msg.sender].permissions  = 1;
        users[msg.sender].joined  = now;
        users[msg.sender].valid  = true;
        
        emit createdUser(users[msg.sender]);
        
        return true;
    }
    function getUser(address person) public view returns(stor.User memory) {
        require(users[person].valid, "User doesn't Exist");
        return users[person];
    }
}

contract userArts is user {
    
    using SafeMath for uint256;

    uint private userArticleId = 0;
    
    stor.userArticles[] public userCatalog;
    
    event createdArticle(stor.userArticles newArticle);
    
    ///collection of user articles
    
    modifier validateUser(address currUser) {
        require(users[currUser].permissions == 1, "Invalid Credentials.");
        _;
    }
    
    function createUserArticle(string memory text, bytes32 title, bytes32 authName, bytes32[] memory references) public validateUser(msg.sender) returns(bool success) {
        
        stor.userArticles memory newArticle = 
        stor.userArticles({
            authAddress: msg.sender,
            authName: authName,
            title: title,
            references: references,
            text: text,
            date: now,
            id: userArticleId = userArticleId.add(1),
            newsArticleId: 0,
            valid: true
        });
        
        userCatalog.push(newArticle);
        
        emit createdArticle(newArticle);
        
        return true;
    }
    
    function getArtByTitle(bytes32 title) public view returns(stor.userArticles memory){  return userCatalog[_searchArtItems(title)]; }
    function getArtByAuthName(bytes32 authName) public view returns(stor.userArticles memory){   return userCatalog[_searchArtItems(authName)];    }
    
    function _searchArtItems(bytes32 item) internal view returns(uint) {
        for(uint i = 0; i < userCatalog.length; i++) {
            if(userCatalog[i].title == item || userCatalog[i].authName == item) {
                return i;
            }
        }
    }
    
    function returnUserCatalog() public view returns(stor.userArticles[] memory){
        require(userCatalog.length > 0, "News Catalog is empty.");
        
        return userCatalog;
    }
}