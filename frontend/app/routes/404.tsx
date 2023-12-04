
import {json, MetaFunction} from "@remix-run/node";

export const meta: MetaFunction = () => {
  return [
    { title: "404 Not found" },
  ];
};

export const loader = async () => {
  return json("", { status: 404 });
};

export default function NotFound() {
  return (
    <h1> 404 Not found </h1>
  );
}
