# Helium, Inc - Denylist

The Helium community requested Helium, Inc. to maintain a temporary Hotspot
Denylist [through an on-chain vote][vote] around block 1,180,295 (approximately
2022-01-14 04:57 UTC).

The Helium compiled firmware of Original Helium Hotspots (and RAK Hotspots) will
use this list in the following manner. Hotspots performing the Challenger role
for the Proof-of-Coverage system:

* will not generate challenges for Hotspots in the denylist.
* will drop witness receipts for Hotspots in the denylist.

We won’t be able to mark individual witness receipts as invalid due to presence
in denylist as it would break consensus rules. A more complex implementation
that includes this could be implemented in the coming weeks as a part of a
[HIP-40][HIP-40] implementation.

Other manufacturers will have the option of loading this denylist or other lists
if they choose to do so and using that feature, their Hotspots will also take
the same actions.

We may, or may not, choose to publish the methodology that is used to generate
these new lists as that would potentially allow suspicious Hotspot deployers to
identify the analysis approaches that we utilize. These lists will be published
as frequently as we determine is necessary. They will be signed by Helium, Inc.
as a part of a multisig with members consisting of community contributors and
other researchers who suppor the work to generate this list.

Since these lists are going to be public, other tools like Explorer and
Hotspotty may use them to visualize suspicious activity. In the coming weeks we
will update the Helium mobile app to include a warning during the transfer
Hotspot process if a Hotspot being transferred is on the suspected list.

We will publish these lists in two forms as releases in this repository:

* A plaintext file that includes every Hotspot’s public key in base68 format.
* A binary xor filter that can be loaded via configuration to activate the above
  feature.

## Instructions

### Maintainers

To use this repository to generate filters, you will need to use the
[xorf-generator](https://github.com/helium/xorf-generator) binary that is
responsible for generating a signed version of a binary xor filter.

#### Updating the denylist

1. Open a PR with a modified `denylist.csv` file to add or remove Hotspots.
   Ensure the file is lexicographically sorted after modifications.
2. Generate a manifest file. Ensure that you are incrementing the serial number.

    ```
    $ xorf-generator manifest generate --input denylist.csv --serial 2022012401 --manifest manifest.json
    ```

3. Generate an unsigned filter and check it into the PR.

    ```
    $ xorf-generator filter generate --input denylist.csv --key public_keys.json --serial 2022012401 --manifest manifest.json --output unsigned.bin
    ```

4. Request signatures from multisig members in the PR using the hash that is
   generated in the `manifest.json` file. Details below.
5. Once sufficient signatures have been provided, update the `manifest.json`
   file to include them in the `signatures` array.
4. Automation should now be able to generate a filter file using this command

    ```
    $ xorf-generator filter generate --input denylist.csv --key public_keys.json --manifest manifest.json --output filter.bin
    ```

5. If run locally, you can also verify the generated filter.

    ```
    $ xorf-generator filter verify --input filter.bin --key public_keys.json
    ```

6. One can also check if a Hotspot is included in a filter.

    ```
    $ xorf-generator filter contains -i filter.bin 112CgbghEZwMwbKUXfz9i9o4Ysxtio4ucGH24zFNYRRU6V2RtJyk
    ```

#### Providing a signature

1. You've probably created a key before this process and have it added to the
   `public_keys.json` file.

    ```
    $ helium-wallet create basic -o signing.key
    ```

2. A Pull Request is opened by another signer in the multisig.
3. Verify the additions to the list of Hotspots using your methodology.
4. Sign the unsigned file provided in the Pull Request.

    ```
    $ helium-wallet -f signing.key sign file unsigned.bin
    ```

4. Provide signature to the Pull Request.

#### Adding / Removing Keys

1. Modify the `public_keys.json` file by adding or removing keys. Don't forget
   to adjust the required keys value if necessary.
2. Generate the new multisig address.

    ```
    $ xorf-generator key info public_keys.json
    ```

3. Update `miner` to use this multisig address.

**Note: A miner will not be able to verify releases with a new multisig until
they have the new multisig address in their configuration.**

[vote]: https://heliumvote.com/14iwaexUYUe5taFgb5hx2BZw74z3TSyonRLYyZU1RbddV4bJest
[HIP-40]: https://github.com/helium/HIP/blob/master/0040-validator-denylist.md