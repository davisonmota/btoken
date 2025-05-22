import BtokenLedger "canister:btoken_icrc1_ledger_canister";

import Error "mo:base/Error";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";
import Text "mo:base/Text";

actor Btoken {
  type TokenInfo = {
    name : Text; 
    symbol : Text; 
    totalSupply : Nat; 
    fee : Nat; 
    mintingPrincipal : Text; 
  }; 

  type TransferArgs = {
    amount : Nat;
    toAccount : BtokenLedger.Account;
  }; 
  
  public func getTokenName(): async Text {
    // Funções Query não podem ser assíncronas
    let name = await BtokenLedger.icrc1_name();
    return name;
  };

  public func getTokenSymbol(): async Text {
    let symbol = await BtokenLedger.icrc1_symbol();
    return symbol;
  };

  public func getTokenTotalSupply(): async Nat {
    let totalSupply = await BtokenLedger.icrc1_total_supply();
    return totalSupply;
  };
  
  public func getTokenFee(): async Nat {
    let fee = await BtokenLedger.icrc1_fee();
    return fee;
  };

  public func getTokenMintingPrincipal() : async Text {
    let mintingAccountOpt = await BtokenLedger.icrc1_minting_account();

    switch (mintingAccountOpt) {
      case (null) { return "Nenhuma conta de mintagem localizada!"; };
      case (?account) {
        return Principal.toText(account.owner);
      };
   };
  };

  public func getTokenInfo() : async TokenInfo {
    let name = await getTokenName();
    let symbol = await getTokenSymbol();
    let totalSupply = await getTokenTotalSupply();
    let fee = await getTokenFee();
    let mintingPrincipal = await getTokenMintingPrincipal();


    let info : TokenInfo = { 
      name = name;
      symbol = symbol;
      totalSupply = totalSupply;
      fee = fee;
      mintingPrincipal = mintingPrincipal;
    };
      
    return info;
  }; 

  public shared func transfer(args : TransferArgs) : async Result.Result<BtokenLedger.BlockIndex, Text> {
    let transferArgs : BtokenLedger.TransferArg = {
      memo = null;
      amount = args.amount;
      from_subaccount = null;
      fee = null;
      to = args.toAccount;
      created_at_time = null;
    };

    try {
      let transferResult = await BtokenLedger.icrc1_transfer(transferArgs);

      switch (transferResult) {
        case (#Err(transferError)) {
          return #err("Não foi possível transferir fundos: " # debug_show (transferError));
        };
        case (#Ok(blockIndex)) { return #ok blockIndex };
      };
    } catch (error : Error) {
      return #err("Mensagem de rejeição: " # Error.message(error));
    };
  };  
};
