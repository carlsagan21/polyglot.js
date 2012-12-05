polyglot = require("../lib/polyglot")
should = require('chai').should()

describe "t", ->

  phrases =
    "hello": "Hello"
    "hi_name_welcome_to_place": "Hi, %{name}, welcome to %{place}!"
    "name_your_name_is_name": "%{name}, your name is %{name}!"

  before ->
    polyglot.extend(phrases)

  it "should translate a simple string", ->
    polyglot.t("hello").should.equal("Hello")

  it "should return the key if translation not found", ->
    polyglot.t("bogus_key").should.equal("bogus_key")

  it "should interpolate", ->
    polyglot.t("hi_name_welcome_to_place", {name: "Spike", place: "the webz"}).should.equal("Hi, Spike, welcome to the webz!")

  it "should interpolate the same placeholder multiple times", ->
    polyglot.t("name_your_name_is_name", {name: "Spike"}).should.equal("Spike, your name is Spike!")

  it "should allow you to supply default values", ->
    polyglot.t("can_i_call_you_name",
      _: "Can I call you %{name}?"
      name: "Robert"
    ).should.equal "Can I call you Robert?"

describe "locale", ->

  it "should default to 'en'", ->
    polyglot.locale().should.equal "en"

  it "should get and set locale", ->
    polyglot.locale("es")
    polyglot.locale().should.equal "es"

    polyglot.locale("fr")
    polyglot.locale().should.equal "fr"

describe "extend", ->

  it "should support multiple extends, overriding old keys", ->
    polyglot.extend {aKey: 'First time'}
    polyglot.extend {aKey: 'Second time'}
    polyglot.t('aKey').should.equal 'Second time'

  it "shouldn't forget old keys", ->
    polyglot.extend {firstKey: 'Numba one', secondKey: 'Numba two'}
    polyglot.extend {secondKey: 'Numero dos'}
    polyglot.t('firstKey').should.equal 'Numba one'

describe "clear", ->

  it "should wipe out old phrases", ->
    polyglot.extend {hiFriend: "Hi, Friend."}
    polyglot.clear()
    polyglot.t("hiFriend").should.equal "hiFriend"


describe "replace", ->

  it "should wipe out old phrases and replace with new phrases", ->
    polyglot.extend {hiFriend: "Hi, Friend.", byeFriend: "Bye, Friend."}
    polyglot.replace {hiFriend: "Hi, Friend."}
    polyglot.t("hiFriend").should.equal "Hi, Friend."
    polyglot.t("byeFriend").should.equal "byeFriend"

describe "pluralize", ->

  phrases =
    num_names: "%{smart_count} Name |||| %{smart_count} Names"

  before ->
    polyglot.extend(phrases)
    polyglot.locale('en')

  it "should support pluralization with an integer", ->
    polyglot.t("num_names", smart_count: 0).should.equal("0 Names")
    polyglot.t("num_names", smart_count: 1).should.equal("1 Name")
    polyglot.t("num_names", smart_count: 2).should.equal("2 Names")
    polyglot.t("num_names", smart_count: 3).should.equal("3 Names")

  it "should support pluralization with an Array", ->
    names = []
    polyglot.t("num_names", smart_count: names).should.equal("0 Names")
    names.push "LTJ Bukem"
    polyglot.t("num_names", smart_count: names).should.equal("1 Name")
    names.push "MC Conrad"
    polyglot.t("num_names", smart_count: names).should.equal("2 Names")

  it "should support pluralization of anything with a 'length' property", ->
    obj = {length: 0}
    polyglot.t("num_names", smart_count: obj).should.equal("0 Names")
    obj.length++
    polyglot.t("num_names", smart_count: obj).should.equal("1 Name")
    obj.length++
    polyglot.t("num_names", smart_count: obj).should.equal("2 Names")
