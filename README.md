# objsrv Cookbook

Todo: Put a description of your cookbook here. Include at a high level the
intent and purpose of why someone would use this cookbook.

## Scope

Todo: Identify the scope of what exactly this cookbook addresses. Are there any
edge cases associated with your cookbook tasks that were decided not to be
supported?

## Requirements

The following environmental variables must be defined:<br>
  Chef_Release = The version of Chef Client to use<br>
  RepoDir = Full path directory on local system where the repos are stored<br>
  HDPATH = Full path directory to store additional HDs<br>

### Platforms

- Redhat 7.x+

### Chef

- Chef 12+

### Dependencies

depends 'nc_base'
depends 'nc_tools'

## Usage

The following environmental variables must be defined:
	HDPATH - The directory where extra hard disk volumes are stored
	chef_release - The version of chef client you want to use
		This version must be avaliable

Todo: This will be unique depending on how the cookbook is developed and the
tools it provides to configure nodes. Here's a simple example of using a
cookbook and it's recipe. You'll want to elaborate on your own steps and include
any necessary steps like setting required attributes.

Place a dependency on the `objsrv` cookbook in your cookbook's
`metadata.rb`.

```
depends 'objsrv'
```

Then, in a recipe:

```
include_recipe 'objsrv::make_nc_os'
```

If your cookbook provides resources, be sure to include examples of how to use
those resources, in addition to the resources documentation section below.

## Attributes

* `default['objsrv']['my_attribute']`: Describe the purpose or usage of
  this attribute. Defaults to `somevalue`. Indicate the attribute type if
  necessary.

## Recipes

### default.rb

Todo: Provide a description for the purpose of this recipe file. What does it
do? When would I use it? Does it invoke other recipes?

## Custom Resources

Todo: You only need to provide documentation for custom resources if your
cookbook actually provides them. Not all cookbooks have custom resources. If you
don't known what this means, then your cookbook probably doesn't have them
either and can omit this documentation.

### resource_name

Todo: Add a description or purpose for this resource. What does it do?

#### Actions

To determine the values for:
override['nc_base']['fp_ver'] = '25'
override['nc_base']['fp_rel'] = '5.50.96.20210309_2049'
Extract OMNIbuxCore zip file and navigate to
8.1.0-TIV-OMNIbusCore-linux-x86_64-FP0025/OMNIbusRepository/composite
look at file repository.xml and find
PLATFORMS_com.ibm.tivoli.omnibus.core after '~' will be the value for fp_rel
%offering.display.name the last octet will be the value for fp_ver

#### Properties

* `property_name` - Description of this property. What is it used for? What is
  it's default value?
* `property_name2` - Description of this property. What is it used for? What is
  it's default value?

#### Examples

todo: Describe this example and what it will accomplish.

```Ruby
# code samples are helpful
objsrv_resource_name 'some value' do
  property_name 'another value'
  property_name2 'foo bar'
  action :do_something
end
```

And don't forgot to show an example for your other actions.

```Ruby
# code samples are helpful
objsrv_resource_name 'some value' do
  property_name 'another value'
  property_name2 'foo bar'
  action :another_action
end
```
