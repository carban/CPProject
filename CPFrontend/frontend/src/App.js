import React, { Component } from "react";
import './App.css';

import { Container } from "reactstrap";
import Custom from "./Custom.jsx";

class App extends Component {
  constructor() {
    super();
    this.state = {}
  }

  render() {
    return (
      <div>
        <header className="Title">
          <center>
            <h1>Tv Shows Cost</h1>
          </center>
        </header>
        <Container fluid>
          <br></br>
          <Custom />
        </Container>
      </div>
    );
  }

}

export default App;
