## Compilation

```bash
elm make src/Main.elm --output=main.js
```
Sound requires http, so use a server like the VSCode Live Server extension if you want audio. 

## Testing
If you want a user install you can check out the install instructions at the github link below. These instructions are for a global installation.
```bash
curl https://sh.rustup.rs -sSf | sh
cargo install --git https://github.com/mpizenberg/elm-test-rs --tag v3.0.1
elm-test-rs
```
