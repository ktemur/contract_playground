pragma solidity >=0.4.22 <0.7.0;

import "./Company.sol";

contract CompanyFactory {
    
    address [] public deployedCompanies;
    
    function newCompany(uint id,
        string title,
        string organizationType,
        string companyAddress,
        uint256 date,
        bool exists)
    public
    returns(address newCompany)
      {
        Company cmpny = new Company(id, title, organizationType, companyAddress, date, exists);
        deployedCompanies.push(cmpny);
        return cmpny;
      }
      
    function getDeployedCompanies () public view returns(address []){
        return deployedCompanies;
    }
    
    function getCompanyInfo (address companyAddress) public view returns(uint, string, string, string, uint256, bool){
         Company cmpny = Company(companyAddress);
         return cmpny.getCompany();
    }
    
    function updateCompanyTitle (address companyAddress, string title) public {
         Company cmpny = Company(companyAddress);
         return cmpny.updateCompanyTitle(title);
    }
    
}
