require 'spec_helper'

describe :passless do
  it do
    is_expected.to run
      .with_params('passfile-label')
      .and_return('7abb4c65bb1de8f0d2e5a0be2967aedcdae30d1d')
  end
end
