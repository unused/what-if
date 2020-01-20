/* global Rails, window */
import React, {useState, useRef} from 'react';
import ReactDOM from 'react-dom';

const LoadingAnimation = () => (
  <div className="sk-folding-cube">
    <div className="sk-cube2 sk-cube" />
    <div className="sk-cube1 sk-cube" />
    <div className="sk-cube4 sk-cube" />
    <div className="sk-cube3 sk-cube" />
  </div>
);

const Upload = () => {
  const filebrowser = useRef(null);
  const triggerFileBrowser = () => filebrowser.current.click();
  const [loading, setLoading] = useState(false);
  const [hover, setHover] = useState(false);

  const upload = event => {
    setLoading(true); // note: if no files are uploaded, this might fail ^^

    console.log('on drop', event, event.target);
    const {files} = event.target;
    for (let i = 0; i < files.length; i++) {
      const body = new FormData();
      body.append('file', files[i]);
      body.append('authenticity_token', Rails.csrfToken());
      fetch('/stories', {method: 'POST', body}).then(() => {
        // fake some waiting time... then reload
        setTimeout(() => window.location.reload(), 5000);
      });
    }
  };

  const handleDrop = event => {
    event.preventDefault();

    let files = [];
    if (event.dataTransfer.items) {
      for (let i = 0; i < event.dataTransfer.items.length; i++) {
        // If dropped items aren't files, reject them
        if (event.dataTransfer.items[i].kind === 'file') {
          files.push(event.dataTransfer.items[i].getAsFile());
        }
      }
    } else {
      // Use DataTransfer interface to access the file(s)
      for (let i = 0; i < event.dataTransfer.files.length; i++) {
        files.push(event.dataTransfer.files[i]);
      }
    }

    upload({target: {files}});
  };

  if (loading) {
    return <LoadingAnimation />;
  }

  return [
    <a
      style={hover ? {background: 'rgba(255, 255, 255, .25)'} : {}}
      onDragOver={event => {
        event.preventDefault();
        setHover(true);
        return false;
      }}
      onDragLeave={() => setHover(false)}
      key="link"
      onDrop={handleDrop}
      onClick={triggerFileBrowser}
      aria-label="upload"
    />,
    <input
      key="file"
      type="file"
      ref={filebrowser}
      accept=".html,.tw"
      onChange={upload}
    />,
  ];
};

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(<Upload />, document.getElementById('upload'));
});
