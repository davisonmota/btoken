import BtokenLedger "canister:btoken_icrc1_ledger_canister";

import Principal "mo:base/Principal";
import Text "mo:base/Text";

actor Btoken {
  public func getTokenName(): async Text {
    // Funções Query não podem ser assíncronas
    let name = await BtokenLedger.icrc1_name();
    return name;
  };
};
