pragma solidity >=0.4.22 <0.7.0;

contract Company {

  struct CompanyInfoStruct {
    uint id;
    string title;
    string organizationType;
    string companyAddress;
    uint256 date;
    bool exists;
  }
  
  CompanyInfoStruct companyInfo;
  
  event LogNewCompany (uint id, string title, string organizationType, string companyAddress);
  
  constructor (uint id,
    string title,
    string organizationType,
    string companyAddress,
    uint256 date,
    bool exists) public {
    companyInfo.id = id;
    companyInfo.title = title;
    companyInfo.organizationType = organizationType;
    companyInfo.companyAddress = companyAddress;
    companyInfo.date = date;
    companyInfo.exists = exists;
    
    LogNewCompany(id, title, organizationType, companyAddress);
  }
  
  function getCompany() public view returns(uint, string, string, string, uint256, bool) {
    return
    (
        companyInfo.id,
        companyInfo.title,
        companyInfo.organizationType,
        companyInfo.companyAddress,
        companyInfo.date,
        companyInfo.exists
    );
  } 
  
  function updateCompanyTitle(string title) public {
    companyInfo.title = title;
  } 

}
