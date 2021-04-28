# TosDisFinance Pool verification and Logo Update Procedure

1: Open and edit "pools.json" file from the main branch

2: Copy your pool contract address from the pool deployment transaction hash and add your pool address at the bottom of addresses under 

    
        "verifiedPoolAddresses"
    

3: Add your token address and direct image link(svg logo preferred) under

    
        "poolTokenImages"
    

 as follows:

    {
      "address": "Your token contract address",
      
      "image_url": "Your token logo direct link"
    }
    
4: Create a Pull request.

5: DONE!!! For quick approval, drop a message at TosDis telegram support.


        Important: Carefully check how other addresses in pools.json file are added and make sure you do not miss any commas.
