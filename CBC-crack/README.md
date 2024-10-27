# Cracking CBC with known plaintexts and predictable IV

You've intercepted a message from a rival engineering school:
```
{ciphertext: [0xb1, 0xce, 0x9a, 0xc7, 0xd3, 0x12], 
         iv: 0x1d
}
```
(Update, Sept 30: The ciphertext initially incorrectly said 0xc'. It should read 0xc7 as shown above).

You know that they are using the ByteCipher in CBC mode. You also know they're using ASCII encoding:

`a = 0x61` and\
`b = 0x62` and\
`...`\
`z = 0x7a`

Unfortunately, you don't know the key k. Fortunately, the developers did not pay attention in SE4472 and decided to "optimize" their encryption app to use a static IV. In this case, they're always using iv: `0x1d`.

From your previous cryptanalysis efforts, you've assembled the following known plaintext/ciphertext pairs for key k:

```
coins   ['0xb1', '0x0b', '0xa3', '0x04', '0xf9']
dense   ['0xb5', '0xce', '0x12', '0xef', '0xcf']
camping ['0xb1', '0xce', '0x9a', '0xc7', '0xf7', '0x94', '0x19']
caution ['0xb1', '0xce', '0x55', '0xd0', '0xcc', '0x9a', '0xa4']
predict ['0xd1', '0x9a', '0x54', '0xd6', '0x05', '0xc6', '0xd3']
```
Use this information to help you decrypt the ciphertext.
