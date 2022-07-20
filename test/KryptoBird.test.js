const {assert} = require('chai')

const KryptoBird = artifacts.require('./KryptoBird');
// check for chai
require ('chai')
.use(require('chai-as-promised'))
.should()

contract('KryptoBird',(accounts) => {
    let contract
    // before tells our test to run this first. 
    before (async () => {
     contract = await KryptoBird.deployed()
    })

    //testing container 
    describe('deployment',async()=> {
        //test samples with writing it 
        it('deploys successfully', async() =>{
           // contract = await KryptoBird.deployed()
            const address = contract.address;
            assert.notEqual(address,'')
            assert.notEqual(address,null)
            assert.notEqual(address,undefined)
            assert.notEqual(address,0x0)
        })
        it('Has a name', async() =>{
            
            const name = await contract.name();
            assert.equal(name,'Kryptobird')
        })
        it('Symbol Matches', async() =>{
            
            const symbol = await contract.symbol()
            assert.equal(symbol,'KBIRDZ')
        })

    })
    // Minting Container 
    describe('minting', async()=>{
        it('creates a new token', async()=>{
            const result = await contract.mint('https...1')
            const totalSupply = await contract.totalSupply()
            // Test?
            assert.equal(totalSupply,1)
            const event = result.logs[0].args 
            // test to check the address from is 0
            assert.equal(event._from,'0x0000000000000000000000000000000000000000', 'from  the contract')
            assert.equal(event._to, accounts[0],'to is message sender')
            // failure: reject the minting
            await contract.mint('https...1').should.be.rejected;

        })
    })
    //Indexing Testing 
    describe('indexing', async()=>{
        it('Lists KryptoBirdz', async() => {
            // minting 3 new tokens 
            await contract.mint('https...2')
            await contract.mint('https...3')
            await contract.mint('https...4')
            const totalSupply = await contract.totalSupply()

        
            // Loop through the list and grap Kbirdz from the list 
            let result = []
            let KryptoBird
            for(i=1; i <= totalSupply; i++){
                KryptoBird = await contract.kryptoBirdz(i -1)
                result.push(KryptoBird)
            }
            //assert that our new array result will equal our expected result 
            let expected = ['https...1','https...2','https...3','https...4']
            assert.equal(result.join(','), expected.join(','))
            

        })
    })
})

