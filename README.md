# Nova Labs - Denylist <!-- omit in toc -->

[vote]: https://heliumvote.com/14iwaexUYUe5taFgb5hx2BZw74z3TSyonRLYyZU1RbddV4bJest
[hip-40]: https://github.com/helium/HIP/blob/master/0040-validator-denylist.md
[issue]: https://github.com/helium/denylist/issues

- [Introduction](#introduction)
  - [Additions to this List](#additions-to-this-list)
  - [Removal from this List](#removal-from-this-list)
- [Instructions for Signers](#instructions-for-signers)
  - [Updating the Denylist](#updating-the-denylist)
  - [Providing a Signature](#providing-a-signature)
  - [Adding / Removing Keys](#adding--removing-keys)

# Introduction

The Helium community requested Nova Labs (formerly Helium, Inc.) to maintain a temporary Hotspot
Denylist [through an on-chain vote][vote] around block `1,180,295` (approximately
2022-01-14 04:57 UTC).

The Helium compiled firmware of Original Helium Hotspots (and RAK Hotspots) will
use this list in the following manner. Hotspots performing the Challenger role
for the Proof-of-Coverage system:

- will not generate challenges for Hotspots in the denylist.
- will drop witness receipts for Hotspots in the denylist.

We won’t be able to mark individual witness receipts as invalid due to presence
in denylist as it would break consensus rules. A more complex implementation
that includes this could be implemented in the coming weeks as a part of a
[HIP-40][hip-40] implementation.

Other manufacturers will have the option of loading this denylist or other lists
if they choose to do so and using that feature, their Hotspots will also take
the same actions.

We may, or may not, choose to publish the methodology that is used to generate
these new lists as that would potentially allow suspicious Hotspot deployers to
identify the analysis approaches that we utilize. These lists will be published
as frequently as we determine is necessary. They will be signed by Helium, Inc.
as a part of a multisig with members consisting of community contributors and
other researchers who support the work to generate this list.

Since these lists are going to be public, other tools like Explorer and
Hotspotty may use them to visualize suspicious activity. In the coming weeks we
will update the Helium mobile app to include a warning during the transfer
Hotspot process if a Hotspot being transferred is on the suspected list.

We will publish these lists in two forms as releases in this repository:

- A plaintext file that includes every Hotspot’s public key in base68 format.
- A binary xor filter that can be loaded via configuration to activate the above
  feature.
  
## Additions to this List

Requesting additions to this list has changed as of 10/27/22 At this time, please visit Crowdspot.io to request any additions to the Denylist.

We welcome contributions to add to the Denylist but may do independent verification to determine whether or not we feel comfortable adding individual Hotspots to this list.

## Removal from this List

Requesting removals to this list has changed as of 10/27/22 At this time, please visit Crowdspot.io to request any removals to the Denylist.

We welcome contributions to the Denylist but may do independent verification to determine whether or not we feel comfortable removing individual Hotspots to this list. 

# Instructions for Signers

To use this repository to generate filters, you will need to use the
[xorf-generator](https://github.com/helium/xorf-generator) binary that is
responsible for generating a signed version of a binary xor filter.

If you are a multisig member you will _also_ need a
[helium-wallet](https://github.com/helium/helium-wallet-rs) release to sign the
filter data.

## Updating the Denylist

1. Open a PR with a modified `denylist.csv` file to add or remove Hotspots.

2. Generate a manifest file. Ensure that you are incrementing the serial number.

   ```shell
   $ xorf-generator manifest generate --input denylist.csv --serial 2022012401
   ```

3. Check in the generated `manifest.json` and push up to the PR

4. Request signatures from multisig members in the PR

5. Once enough signatures gave been provided, verify the manifest using:

   ```shell
   $ xorf-generator manifest verify --input denylist.csv
   ```

   If all signatures verify approve the PR and merge it

6. The automatic CI will generate the final filter.bin from master using:

   ```
   $ xorf-generator filter generate --input denylist.csv
   ```

   which will generate a filter.bin and create a github release for that filter.bin
   with the given serial number.

   **NOTE** This step is automated and just provided for clarity

## Providing a Signature

1.  You've probably created a key before this process and have it added to the
    `public_key.json` file.

    ```
    $ helium-wallet create basic -o signing.key
    ```

2.  A Pull Request is opened by another signer in the multisig.

3.  Verify the additions to the list of Hotspots using your methodology.

4.  Create the signing data using:

    ```shell
    $ xorf-generator manifest verify --input denylist.csv
    ```

    which will generate a `data.bin` to sign

5.  Sign the data file:

    ```
    $ helium-wallet -f signing.key sign file data.bin
    ```

6.  Add the resulting signature json to the `signature` array in the
    manifest.json of the PR.

    **NOTE** that this is a JSON file and that the `signatures` field is a a
    comma separated list of address, signature pairs.

7.  You can verify the manifest using:

    ```shell
    $ xorf-generator manifest verify --input denylist.csv
    ```

    which will output all the signatures and whether they are valid or not.

8.  Submit the updated manifest.json to the same PR

## Adding / Removing Keys

1. Modify the `public_key.json` file by adding or removing keys. Don't forget
   to adjust the required keys value if necessary.
2. Generate the new multisig address.

   ```
   $ xorf-generator key info public_key.json
   ```

3. Update `miner` to use this multisig address.

**Note: A miner will not be able to verify releases with a new multisig until
they have the new multisig address in their configuration.**
