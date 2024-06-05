const fs = require("fs");

const passwords = ["Snuffles", "Snowball"];

//Morty’s answer is less than 10 characters long and does not include any special characters.
//https://pwning.owasp-juice.shop/companion-guide/latest/part2/broken-anti-automation.html#_reset_mortys_password_via_the_forgot_password_mechanism

//Leetspeak (d0g)
//Shift letter (dog->eoh)
//Reversal (dog->god)
//With Noise (dog123)
//Case Variations (DoG)
//
const leetDict = {
  o: ["0", "o"],
  l: ["1", "l"],
  i: ["1", "i"],
  z: ["2", "z"],
  e: ["3", "e"],
  a: ["4", "a"],
  s: ["5", "s"],
  g: ["6", "9", "g"],
  t: ["7", "t"],
  b: ["8", "b"],
};

function generateLeetspeakVariations(str) {
  const results = [];

  function permute(prefix, remaining) {
    if (remaining.length === 0) {
      results.push(prefix);
    } else {
      const char = remaining[0].toLowerCase();
      const nextChars = leetDict[char] || [char];
      nextChars.forEach((nextChar) => {
        permute(prefix + nextChar.toLowerCase(), remaining.slice(1));
        permute(prefix + nextChar.toUpperCase(), remaining.slice(1));
      });
    }
  }

  permute("", str);

  return results;
}

function exportToTxt(filename, data) {
  fs.writeFile(filename, data.join("\n"), (err) => {
    if (err) {
      console.error("Error writing to file", err);
    } else {
      console.log(`Wordlist saved to ${filename}`);
    }
  });
}

function generateRandomIP() {
  return `${Math.floor(Math.random() * 256)}.${Math.floor(
    Math.random() * 256
  )}.${Math.floor(Math.random() * 256)}.${Math.floor(Math.random() * 256)}`;
}

// Function to generate a specified number of IP addresses
function generateIPList(count) {
  const ips = [];
  for (let i = 0; i < count; i++) {
    ips.push(generateRandomIP());
  }
  return ips;
}

// Test the function with the word "Snowball"
const originalWord = "Snowball";
const leetspeakVariations = passwords
  .map((original) => generateLeetspeakVariations(original))
  .flatMap((d) => d);

// Print the variations
console.log(`Original: ${originalWord}`);
console.log("Leetspeak Variations:");
leetspeakVariations.forEach((variation) => console.log(variation));

const ips = generateIPList(leetspeakVariations.length);

exportToTxt("mock-ips.txt", ips);

exportToTxt("morty-pet.txt", leetspeakVariations);
