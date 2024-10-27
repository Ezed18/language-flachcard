import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";

actor {
  type CardId = Nat;
  
  type Flashcard = {
    id : CardId;
    word : Text;
    translation : Text;
    difficulty : Text;
    lastReviewed : Time.Time;
  };

  var cards = Buffer.Buffer<Flashcard>(0);

  public func addCard(word : Text, translation : Text, difficulty : Text) : async CardId {
    let cardId = cards.size();
    let newCard : Flashcard = {
      id = cardId;
      word = word;
      translation = translation;
      difficulty = difficulty;
      lastReviewed = Time.now();
    };
    cards.add(newCard);
    cardId;
  };

  public query func getCard(cardId : CardId) : async ?Flashcard {
    if (cardId < cards.size()) {
      ?cards.get(cardId);
    } else {
      null;
    };
  };

  public func updateCard(cardId : CardId, word : Text, translation : Text, difficulty : Text) : async Bool {
    if (cardId < cards.size()) {
      let updatedCard : Flashcard = {
        id = cardId;
        word = word;
        translation = translation;
        difficulty = difficulty;
        lastReviewed = Time.now();
      };
      cards.put(cardId, updatedCard);
      true;
    } else {
      false;
    };
  };

  public query func getAllCards() : async [Flashcard] {
    Buffer.toArray(cards);
  };

  public query func getCardsByDifficulty(difficulty : Text) : async [Flashcard] {
    let results = Buffer.Buffer<Flashcard>(0);
    for (card in cards.vals()) {
      if (Text.equal(card.difficulty, difficulty)) {
        results.add(card);
      };
    };
    Buffer.toArray(results);
  };
};