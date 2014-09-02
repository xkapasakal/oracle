# oracle-cookbook

Installs Oracle Database 11g Release 2. Enterprise Edition (11.2.0.3.0).

## Supported Platforms

- CentOS 6.5

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['oracle']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage
Approximate time = (50m22.51s)

### oracle::default

Include `oracle` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[oracle::default]"
  ]
}
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: YOUR_NAME (<YOUR_EMAIL>)
