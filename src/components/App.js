import React, { Component } from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from '../abis/KryptoBird.json';
import {MDBCard, MDBCardBody,MDBCardText,MDBCardImage,MDBBtn, MDBCardTitle} from 'mdb-react-ui-kit';


class App extends Component {

    async componentDidMount (){
        await this.loadWeb3();
        await this.loadBlockchainData();
    }
    


    // first thing is to detect etheruem provider like metamask. 
    async loadWeb3(){
        const provider = await detectEthereumProvider();
        // modern browsers check 
        // if there is a provider, then log it is working 
        if (provider){
            console.log('Ethereum wallet is connected')
            window.web3 = new Web3(provider)
        } else {
            // no etherum provider
            console.log('no eth wallet detected')
        }

    }

    async loadBlockchainData(){
        const web3 = window.web3
        const accounts = await web3.eth.getAccounts();
        this.setState({account:accounts[0]})
     //   console.log(this.state.account);
        const networkId = await web3.eth.net.getId()
        const networkData = KryptoBird.networks[networkId]
        if (networkData){
            const abi = KryptoBird.abi;
            const address = networkData.address;
            const contract = new web3.eth.contract(abi,address);
            this.setState({contract})
            console.log(this.state.contract)
            // call the total supply of our krypto Birdz
            // grab the total supply in the front end and log the results
            const totalSupply = await contract.methods.totalSupply().call()
            this.setState({totalSupply})
            // setup an array to keep track of tokens. 
            // load the kryptobirdz. 
            for(let i=1; i <= totalSupply; i++){
                const KryptoBird = await contract.methods.kryptoBirdz(i -1).call()
                this.setState({
                    KryptoBirdz:[...this.state.KryptoBirdz, KryptoBird]
                })
                console.log(this.state.kryptoBirdz)
            }

        }else{
            window.alert('Smart Contract is not deployed')
        }
    } 

    // with minting we are sendnig information, and we need to specify the account. 

    mint = (KryptoBird) => {
        this.state.contract.methods.mint(KryptoBird).send({from:this.state.account})
        .once('receipt', (receipt)=> {
            this.setState({
                KryptoBirdz:[...this.state.KryptoBirdz, KryptoBird]
            })
        })
    }

    constructor(props){
        // to handle the state 
        super(props);
        this.state = {
            account: '',
            contract:null,
            totalSupply:0,
            KryptoBirdz:[]
        }

    }


    render() {
        return (
            <div>
                <nav className="navbar navbar-dark fixed-top bg-dark">
                <div className="navbar-brand col-sm-3 col-md-3 mr-0" style={{color:'white'}}>
                    
                    Krypto birds NFT
                </div>
                <ul className="navbar-nav px3 ">
                <li className="nav-item text-nowrap d-none d-sm-none d-sm-block"></li>
                <small className="text-white">
                    {this.state.account}
                </small>
                </ul>
                </nav>


                <div className="container-fluid mt-1">
                    <div className="row">
                        <main role ="main" className="col-lg-12 d-flex text-center">
                            <div className='content mr-auto ml-auto' style={{opacity:'0.8'}}>   
                                <h1 style={{color:"white"}}>KryptoBirdz - NFT </h1>
                                <form onSubmit={(event)=> {
                                    event.preventDefault()
                                    const KryptoBird = this.KryptoBird.value 
                                    this.mint(KryptoBird)
                                }}>
                                    <input type='text' placeholder="add a file location" className="form-control mb-2" ref={(input)=>{this.KryptoBird = input}}></input>
                                    <input type='submit' value='MINT' className="btn btn-primary" style={{margin:'6px'}}></input>
                                </form>
                            </div>
                        </main>
                    </div>
                    <hr></hr>

                   <div >
                        {this.state.kryptoBirdz.map((KryptoBird,key)=>{

                            return(
                                <div>
                                    <div>
                                        <MDBCard className="token img" style={{maxWidth:'22rem'}} />
                                        <MDBCardImage src={KryptoBird} position='top' height='250rem' style={{marginRight:'4px'}} />
                                        <MDBCardBody>
                                        <MDBCardTitle>KryptoBirdz</MDBCardTitle>
                                        <MDBCardText>
                                            The KryptoBirdz are 20 uniquely generated Kbirdz from the no where. 

                                        </MDBCardText>
                                        <MDBBtn href={KryptoBird}>Download</MDBBtn>
                                        </MDBCardBody>
                                    </div>
                                </div>
                            )
                        })}

                    </div>
                </div>
                
            </div>
        )
    }
}

export default App;