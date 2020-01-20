import React from 'react';
import ReactDOM from 'react-dom';

import App from 'components/application';

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <App />,
    document.querySelector('main').appendChild(document.createElement('div')),
  );
});
