from brownie import Lottery, accounts, config, network
from web3 import Web3


def test_get_entrance_fee():
    account = accounts[0]
    lotter = Lottery.deploy(
        config["networks"][network.show_active()]["eth_usd_price_feed"],
        {"from": account},
    )
    assert lotter.getEntranceFee() > Web3.toWei(0.01, "ether")
    assert lotter.getEntranceFee() < Web3.toWei(0.02, "ether")
